import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safenest/features/location/presentation/views/custom_map_marker.dart';

class LocationSelectorPage extends StatefulWidget {
  final LatLng initialLocation;
  final Function(LatLng, String) onLocationSelected;

  const LocationSelectorPage({
    Key? key,
    required this.initialLocation,
    required this.onLocationSelected,
  }) : super(key: key);

  @override
  _LocationSelectorPageState createState() => _LocationSelectorPageState();
}

class _LocationSelectorPageState extends State<LocationSelectorPage> {
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};
  List<Map<String, dynamic>> _nearbySchools = [];

  @override
  void initState() {
    super.initState();
    _searchNearbySchools();
  }

  Future<void> _searchNearbySchools() async {
    // Simulated API call to search for nearby schools
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _nearbySchools = [
        {
          'name': 'Springfield Elementary School',
          'latitude': widget.initialLocation.latitude + 0.01,
          'longitude': widget.initialLocation.longitude - 0.01,
        },
        {
          'name': 'Central High School',
          'latitude': widget.initialLocation.latitude - 0.005,
          'longitude': widget.initialLocation.longitude + 0.005,
        },
        {
          'name': 'Oakwood Academy',
          'latitude': widget.initialLocation.latitude + 0.008,
          'longitude': widget.initialLocation.longitude + 0.003,
        },
      ];
      _updateMarkers();
    });
  }

  void _updateMarkers() {
    _markers.clear();
    for (var school in _nearbySchools) {
      _markers.add(
        Marker(
          markerId: MarkerId(school['name']),
          position: LatLng(school['latitude'], school['longitude']),
          infoWindow: InfoWindow(
            title: school['name'],
            onTap: () => widget.onLocationSelected(
              LatLng(school['latitude'], school['longitude']),
              school['name'],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select School Location')),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.initialLocation,
              zoom: 14,
            ),
            onMapCreated: (controller) => _mapController = controller,
            markers: _markers,
          ),
          if (_nearbySchools.isEmpty)
            Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}