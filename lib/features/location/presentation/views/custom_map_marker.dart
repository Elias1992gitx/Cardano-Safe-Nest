import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'dart:async';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomGoogleMapsMarkers extends StatefulWidget {
  const CustomGoogleMapsMarkers({
    super.key,
    this.width,
    this.height,
    this.markersLatLng,
    this.markerIcon,
    this.jsonMapsString,
    this.choosenMarker,
    this.enableZoomGesture,
    this.enableZoomControl,
    this.zoomLevel,
    this.minimumZoom,
    this.maximumZoom,
    this.showMapsCircles,
    this.mapsCirclesDiameter,
    this.mapsCirclesFillColor,
    this.mapsCircleBorderColor,
    this.mapsCircleBorderWidth,
  });

  final double? width;
  final double? height;
  final List<LatLng>? markersLatLng;
  final Icon? markerIcon;
  final String? jsonMapsString;
  final Future Function(LatLng? latLng, String? placeName)? choosenMarker;
  final bool? enableZoomGesture;
  final bool? enableZoomControl;
  final double? zoomLevel;
  final double? minimumZoom;
  final double? maximumZoom;
  final bool? showMapsCircles;
  final double? mapsCirclesDiameter;
  final Color? mapsCirclesFillColor;
  final Color? mapsCircleBorderColor;
  final int? mapsCircleBorderWidth;

  @override
  State<CustomGoogleMapsMarkers> createState() => _CustomGoogleMapsMarkersState();
}

class _CustomGoogleMapsMarkersState extends State<CustomGoogleMapsMarkers> {
  final Completer<gmaps.GoogleMapController> _controller = Completer<gmaps.GoogleMapController>();
  gmaps.BitmapDescriptor? markerIcon;
  Set<gmaps.Marker> markers = {};
  Set<gmaps.Circle> circles = {};

  @override
  void initState() {
    super.initState();
    _createMarkerIcon();
    _createCircles();
  }

  Future<void> _createMarkerIcon() async {
    final icon = await _getBytesFromCanvas(
      widget.markerIcon ?? const Icon(Icons.home, size: 40, color: Colors.red),
      size: 80,
    );
    setState(() {
      markerIcon = gmaps.BitmapDescriptor.fromBytes(icon);
    });
  }

  Future<Uint8List> _getBytesFromCanvas(Icon icon, {required double size}) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final painter = _IconPainter(icon);
    final constraints = BoxConstraints(
      maxWidth: size,
      maxHeight: size,
    );
    painter.paint(canvas, constraints.biggest);
    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  void _addMarker(LatLng latLng) {
    setState(() {
      markers.clear();
      markers.add(
        gmaps.Marker(
          markerId: const gmaps.MarkerId('selected_location'),
          position: gmaps.LatLng(latLng.latitude, latLng.longitude),
          icon: markerIcon ?? gmaps.BitmapDescriptor.defaultMarker,
        ),
      );
    });
  }

  void _createCircles() {
    if (widget.showMapsCircles == true && widget.markersLatLng != null) {
      for (int i = 0; i < widget.markersLatLng!.length; i++) {
        circles.add(
          gmaps.Circle(
            circleId: gmaps.CircleId(
                '${widget.markersLatLng![i].latitude.toString()},${widget.markersLatLng![i].longitude.toString()}'),
            center: gmaps.LatLng(widget.markersLatLng![i].latitude,
                widget.markersLatLng![i].longitude),
            radius: widget.mapsCirclesDiameter ?? 1000,
            fillColor: widget.mapsCirclesFillColor ?? Colors.blue.withOpacity(0.5),
            strokeColor: widget.mapsCircleBorderColor ?? Colors.blue,
            strokeWidth: widget.mapsCircleBorderWidth ?? 1,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double? zoomLevelVar = widget.zoomLevel ?? 14;
    gmaps.MinMaxZoomPreference minMaxZoom = gmaps.MinMaxZoomPreference(
        widget.minimumZoom, widget.maximumZoom);

    List<double> latitudes =
        widget.markersLatLng?.map((latLng) => latLng.latitude).toList() ?? [];
    List<double> longitudes =
        widget.markersLatLng?.map((latLng) => latLng.longitude).toList() ?? [];

    double averageLatitude = latitudes.isNotEmpty ? latitudes.reduce((a, b) => a + b) / latitudes.length : 0;
    double averageLongitude = longitudes.isNotEmpty ? longitudes.reduce((a, b) => a + b) / longitudes.length : 0;

    gmaps.LatLng initialPosition = latitudes.isNotEmpty && longitudes.isNotEmpty
        ? gmaps.LatLng(averageLatitude, averageLongitude)
        : const gmaps.LatLng(0, 0);

    return gmaps.GoogleMap(
      zoomControlsEnabled: widget.enableZoomControl ?? true,
      zoomGesturesEnabled: widget.enableZoomGesture ?? true,
      initialCameraPosition: gmaps.CameraPosition(
        target: initialPosition,
        zoom: zoomLevelVar,
      ),
      markers: markers,
      circles: circles,
      minMaxZoomPreference: minMaxZoom,
      onMapCreated: (gmaps.GoogleMapController controller) {
        _controller.complete(controller);
        if (widget.jsonMapsString != null) {
          controller.setMapStyle(widget.jsonMapsString!);
        }
      },
      onTap: (LatLng latLng) async {
        List<Placemark> placemarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
        String placeName = placemarks.isNotEmpty ? placemarks.first.name ?? '' : '';
        _addMarker(latLng);
        widget.choosenMarker!(latLng, placeName);
      },
    );
  }
}

class _IconPainter extends CustomPainter {
  final Icon icon;

  _IconPainter(this.icon);

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: String.fromCharCode(icon.icon!.codePoint),
      style: TextStyle(
        fontSize: icon.size,
        color: icon.color,
        fontFamily: icon.icon!.fontFamily,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset.zero);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}