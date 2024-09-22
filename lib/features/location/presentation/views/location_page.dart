import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconly/iconly.dart';
import 'package:safenest/core/common/widgets/custom_icon_button.dart';
import 'package:safenest/core/extensions/context_extensions.dart';
import 'package:safenest/features/location/domain/entity/safe_location.dart';
import 'package:safenest/features/location/domain/entity/child_location.dart';
import 'package:lottie/lottie.dart' as lt;

class LocationDashboard extends StatefulWidget {
  final List<SafeLocation> safeLocations;
  final List<ChildLocation> childLocations;

  const LocationDashboard({
    super.key,
    required this.safeLocations,
    required this.childLocations,
  });

  @override
  _LocationDashboardState createState() => _LocationDashboardState();
}

class _LocationDashboardState extends State<LocationDashboard>
    with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  Set<Circle> _safeZones = {};
  Set<Marker> _childMarkers = {};
  late AnimationController _pulseController;
  bool _mapReady = false;

  @override
  void initState() {
    super.initState();
    _createChildMarkers();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _createSafeZones().then((_) => setState(() {}));
  }

  void _createChildMarkers() {
    _childMarkers = widget.childLocations.map((childLocation) {
      return Marker(
        markerId: MarkerId(childLocation.childId),
        position: LatLng(
            childLocation.location.latitude, childLocation.location.longitude),
        infoWindow: InfoWindow(title: "Child ${childLocation.childId}"),
      );
    }).toSet();
  }


  Future<void> _createSafeZones() async {
    _safeZones = widget.safeLocations.map((safeLocation) {
      return Circle(
        circleId: CircleId(safeLocation.id),
        center: LatLng(
            safeLocation.location.latitude, safeLocation.location.longitude),
        radius: safeLocation.radius,
        fillColor: Colors.blue.withOpacity(0.3),
        strokeColor: Colors.blue,
        strokeWidth: 2,
      );
    }).toSet();

    final pulsingIcon = await _createPulsingMarkerIcon();
    _childMarkers.addAll(widget.safeLocations.map((safeLocation) {
      return Marker(
        markerId: MarkerId('pulse_${safeLocation.id}'),
        position: LatLng(
            safeLocation.location.latitude, safeLocation.location.longitude),
        icon: BitmapDescriptor.fromBytes(pulsingIcon),
        zIndex: 2,
      );
    }));
  }



  Future<Uint8List> _createPulsingMarkerIcon() async {
    final double size = 120;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromPoints(Offset(0.0, 0.0), Offset(size, size)));

    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final animationProgress = _pulseController.value;
    final maxRadius = size / 2;
    final currentRadius = maxRadius * (0.5 + 0.5 * animationProgress);

    canvas.drawCircle(Offset(size / 2, size / 2), currentRadius, paint);

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.toInt(), size.toInt());
    final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);

    return pngBytes!.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          _createSafeZones(); // Recreate markers with updated pulsing effect
          return GoogleMap(
            onMapCreated: (controller) {
              setState(() {
                _mapController = controller;
                _mapReady = true;
              });
              _focusOnAllLocations();
              _setMapStyle();
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(
                widget.childLocations.first.location.latitude,
                widget.childLocations.first.location.longitude,
              ),
              zoom: 12,
            ),
            circles: _safeZones,
            markers: _childMarkers,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
            minMaxZoomPreference: const MinMaxZoomPreference(3, 20),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            compassEnabled: true,
            mapToolbarEnabled: false,
            tiltGesturesEnabled: true,
            rotateGesturesEnabled: true,
            scrollGesturesEnabled: true,
            mapType: MapType.normal,
            onCameraMove: (_) {
              if (_mapReady) {
                setState(() {});
              }
            },
          );
        },
      ),
      floatingActionButton: MapControlPanel(
        onZoomIn: () => _mapController?.animateCamera(CameraUpdate.zoomIn()),
        onZoomOut: () => _mapController?.animateCamera(CameraUpdate.zoomOut()),
        onFocusLocations: _focusOnAllLocations,
      ),
    );
  }

  void _setMapStyle() async {
    String style = await DefaultAssetBundle.of(context)
        .loadString('assets/map_theme/light_theme.json');
    _mapController?.setMapStyle(style);
  }

  List<Widget> _buildPulsingCircles() {
    return widget.safeLocations.map((safeLocation) {
      return _PulsingCircleOverlay(
        key: ValueKey(safeLocation.id),
        location: LatLng(
          safeLocation.location.latitude,
          safeLocation.location.longitude,
        ),
        pulseController: _pulseController,
        mapController: _mapController!,
      );
    }).toList();
  }

  void _focusOnAllLocations() {
    if (widget.childLocations.isEmpty || _mapController == null) return;
    final bounds = _calculateBounds();
    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 50),
    );
  }

  LatLngBounds _calculateBounds() {
    double minLat = double.infinity;
    double maxLat = -double.infinity;
    double minLng = double.infinity;
    double maxLng = -double.infinity;

    for (var childLocation in widget.childLocations) {
      final lat = childLocation.location.latitude;
      final lng = childLocation.location.longitude;
      minLat = minLat < lat ? minLat : lat;
      maxLat = maxLat > lat ? maxLat : lat;
      minLng = minLng < lng ? minLng : lng;
      maxLng = maxLng > lng ? maxLng : lng;
    }

    for (var safeLocation in widget.safeLocations) {
      final lat = safeLocation.location.latitude;
      final lng = safeLocation.location.longitude;
      minLat = minLat < lat ? minLat : lat;
      maxLat = maxLat > lat ? maxLat : lat;
      minLng = minLng < lng ? minLng : lng;
      maxLng = maxLng > lng ? maxLng : lng;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  void _updateBounds(double lat, double lng, double minLat, double maxLat,
      double minLng, double maxLng) {
    minLat = minLat < lat ? minLat : lat;
    maxLat = maxLat > lat ? maxLat : lat;
    minLng = minLng < lng ? minLng : lng;
    maxLng = maxLng > lng ? maxLng : lng;
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _mapController?.dispose();
    super.dispose();
  }
}

class _PulsingCircleOverlayState extends State<_PulsingCircleOverlay> {
  Offset? _screenCoordinate;

  @override
  void initState() {
    super.initState();
    _updateScreenCoordinate();
  }

  void _updateScreenCoordinate() {
    widget.mapController
        .getScreenCoordinate(widget.location)
        .then((screenCoordinate) {
      if (mounted) {
        setState(() {
          _screenCoordinate = Offset(
              screenCoordinate.x.toDouble(), screenCoordinate.y.toDouble());
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.pulseController,
      builder: (context, child) {
        return CustomPaint(
          painter: _CirclePainter(
            location: widget.location,
            progress: widget.pulseController.value,
            screenCoordinate: _screenCoordinate,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _PulsingCircleOverlay extends StatefulWidget {
  final LatLng location;
  final AnimationController pulseController;
  final GoogleMapController mapController;

  const _PulsingCircleOverlay({
    Key? key,
    required this.location,
    required this.pulseController,
    required this.mapController,
  }) : super(key: key);

  @override
  _PulsingCircleOverlayState createState() => _PulsingCircleOverlayState();
}

class _CirclePainter extends CustomPainter {
  final LatLng location;
  final double progress;
  final Offset? screenCoordinate;

  _CirclePainter({
    required this.location,
    required this.progress,
    required this.screenCoordinate,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (screenCoordinate == null) return;

    final paint = Paint()
      ..color = Colors.blue.withOpacity(1 - progress)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      screenCoordinate!,
      20 + (30 * progress),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _CirclePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.screenCoordinate != screenCoordinate;
  }
}


class MapControlPanel extends StatefulWidget {
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onFocusLocations;

  const MapControlPanel({
    Key? key,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onFocusLocations,
  }) : super(key: key);

  @override
  _MapControlPanelState createState() => _MapControlPanelState();
}

class _MapControlPanelState extends State<MapControlPanel> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: 60,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildControlButton(
                _isExpanded ? Icons.close : IconlyLight.more_circle,
                _toggleExpand,
                isMainButton: true,
              ),
              ClipRect(
                child: SizeTransition(
                  sizeFactor: _animation,
                  child: Column(
                    children: [
                      _buildControlButton(IconlyLight.plus, widget.onZoomIn),
                      _buildControlButton(Icons.remove, widget.onZoomOut),
                      _buildControlButton(Icons.center_focus_strong, widget.onFocusLocations),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildControlButton(IconData icon, VoidCallback onPressed, {bool isMainButton = false}) {
    return CustomIconButton(
      icon: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: context.theme.primaryColor, size: isMainButton ? 38 : 30),
          ],
        ),
      ),
      onPressed: onPressed,
      buttonSize: 60,
      fillColor: Colors.transparent,
      borderColor: Colors.transparent,
      borderWidth: 0,
      borderRadius: BorderRadius.circular(30),
      gradient: isMainButton
          ? LinearGradient(
        colors: [context.theme.primaryColor.withOpacity(0.1), context.theme.primaryColor.withOpacity(0.3)],
        begin: Alignment.topCenter,
        end: Alignment.bottomRight,
      )
          : null, // Add padding to ensure the icon is centered
    );
  }
}



