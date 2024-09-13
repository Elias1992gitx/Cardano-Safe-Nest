import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
    _createSafeZones();
    _createChildMarkers();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  void _createSafeZones() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              setState(() {
                _mapController = controller;
                _mapReady = true;
              });
              _focusOnAllLocations();
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
            zoomControlsEnabled: true,
            minMaxZoomPreference: const MinMaxZoomPreference(1, 20),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onCameraMove: (_) {
              if (_mapReady) {
                setState(() {});
              }
            },
          ),
          if (_mapReady) ..._buildPulsingCircles(),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: _focusOnAllLocations,
              child: const Icon(Icons.center_focus_strong),
            ),
          ),
        ],
      ),
    );
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
    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
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
    widget.mapController.getScreenCoordinate(widget.location).then((screenCoordinate) {
      if (mounted) {
        setState(() {
          _screenCoordinate = Offset(screenCoordinate.x.toDouble(), screenCoordinate.y.toDouble());
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