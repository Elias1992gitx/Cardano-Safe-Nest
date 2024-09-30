import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safenest/features/location/presentation/views/custom_map_marker.dart';

class LocationSelectorPage extends StatelessWidget {
  final LatLng initialLocation;
  final Function(LatLng, String) onLocationSelected;

  const LocationSelectorPage({
    super.key,
    required this.initialLocation,
    required this.onLocationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: CustomGoogleMapsMarkers(
        markersLatLng: [initialLocation],
        choosenMarker: (latLng, placeName) {
          onLocationSelected(latLng!, placeName!);
          Navigator.of(context).pop();
          return Future.value();
        },
        enableZoomGesture: true,
        enableZoomControl: true,
        zoomLevel: 14,
        minimumZoom: 10,
        maximumZoom: 18,
        showMapsCircles: false,
      ),
    );
  }
}