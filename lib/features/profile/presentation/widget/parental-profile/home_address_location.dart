import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as gc;
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safenest/features/location/presentation/views/custom_map_marker.dart';
import 'package:location/location.dart';

class HomeAddressLocation extends StatefulWidget {
  final Function(LatLng, String) onLocationSelected;
  final LatLng? initialLocation;
  final String? initialAddress;

  const HomeAddressLocation({
    Key? key,
    required this.onLocationSelected,
    this.initialLocation,
    this.initialAddress,
  }) : super(key: key);

  @override
  _HomeAddressLocationState createState() => _HomeAddressLocationState();
}

class _HomeAddressLocationState extends State<HomeAddressLocation> {
  late GoogleMapController _mapController;
  LatLng? _selectedLocation;
  String _selectedAddress = '';
  LatLng? _initialLocation;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
    _selectedAddress = widget.initialAddress ?? '';
    _initialLocation = widget.initialLocation;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showLocationConsentDialog();
    });
  }

  Future<void> _showLocationConsentDialog() async {
    bool? consent = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          title: const Text('Use Current Location'),
          content: const Text('Do you want to use your current location as your home address?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (consent == true) {
      _getCurrentLocation();
    }
  }


  Future<void> _getCurrentLocation() async {
    Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    setState(() {
      _initialLocation = LatLng(_locationData.latitude!, _locationData.longitude!);
      _selectedLocation = _initialLocation;
    });

    List<gc.Placemark> placemarks = await gc.placemarkFromCoordinates(
        _locationData.latitude!, _locationData.longitude!);
    setState(() {
      _selectedAddress = placemarks.isNotEmpty ? placemarks.first.name ?? '' : '';
    });

    widget.onLocationSelected(_initialLocation!, _selectedAddress);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: AlignmentDirectional.topCenter,
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 15,
              vertical: 25,
            ),
            child: Text(
              "Where are you located?",
              style: GoogleFonts.plusJakartaSans(
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: _initialLocation == null
              ? const Center(child: CircularProgressIndicator())
              : CustomGoogleMapsMarkers(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.6,
            markersLatLng: [_initialLocation!],
            enableZoomGesture: true,
            enableZoomControl: true,
            zoomLevel: 14,
            minimumZoom: 10,
            maximumZoom: 18,
            markerIcon: const Icon(Icons.home, size: 40, color: Colors.red),
            choosenMarker: (latLng, placeName) async {
              if (latLng != null) {
                setState(() {
                  _selectedLocation = latLng;
                  _selectedAddress = placeName ?? '';
                });
                widget.onLocationSelected(latLng, placeName ?? '');
              }
              return;
            },
          ),
        ),
        if (_selectedLocation != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Selected Address: $_selectedAddress',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}