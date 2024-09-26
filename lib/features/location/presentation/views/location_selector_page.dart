import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:safenest/features/location/presentation/views/custom_map_marker.dart';

class LocationSelectorPage extends StatelessWidget {
  final LatLng initialLocation;
  final Function(LatLng, String) onLocationSelected;

  const LocationSelectorPage({
    Key? key,
    required this.initialLocation,
    required this.onLocationSelected,
  }) : super(key: key);

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