import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' show cos, sqrt, asin, pi, sin;
import 'package:google_fonts/google_fonts.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:safenest/core/common/widgets/custom_form_field.dart';

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
  List<Map<String, dynamic>> _allSchools = [];
  List<Map<String, dynamic>> _filteredSchools = [];
  List<Map<String, dynamic>> _recommendedSchools = [];
  bool _isLoading = true;
  String _errorMessage = '';
  final double _searchRadius = 50; // 50 km radius
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  LatLng? _selectedLocation;
  Timer? _debounce;
  bool _showTip = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _searchFocusNode.addListener(() {
      setState(() {}); // Rebuild to show/hide recommendations
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _selectedLocation = LatLng(position.latitude, position.longitude);
      });
      _searchNearbySchools();
    } catch (e) {
      setState(() {
        _errorMessage = 'Error getting current location: ${e.toString()}';
      });
    }
  }

  Future<void> _searchNearbySchools() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // In a real-world scenario, you would make an API call here
      // to fetch schools within the 50 km radius of _selectedLocation
      await Future.delayed(const Duration(seconds: 2)); // Simulating API call

      _allSchools = [
        {
          'name': 'Nearby Elementary School',
          'keywords': ['elementary', 'primary', 'kids', 'children'],
          'latitude': _selectedLocation!.latitude + 0.01,
          'longitude': _selectedLocation!.longitude - 0.01
        },
        {
          'name': 'Local High School',
          'keywords': ['high school', 'secondary', 'teens'],
          'latitude': _selectedLocation!.latitude - 0.005,
          'longitude': _selectedLocation!.longitude + 0.005
        },
        {
          'name': 'Community College',
          'keywords': ['college', 'higher education', 'adult education'],
          'latitude': _selectedLocation!.latitude + 0.008,
          'longitude': _selectedLocation!.longitude + 0.008
        },
        // Add more schools here...
      ];
      _filterSchools();
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterSchools() {
    final searchTerm = _searchController.text.toLowerCase();
    setState(() {
      _filteredSchools = _allSchools.where((school) {
        final distance = _calculateDistance(
          _selectedLocation!.latitude,
          _selectedLocation!.longitude,
          school['latitude'],
          school['longitude'],
        );
        final nameMatch = school['name'].toLowerCase().contains(searchTerm);
        final keywordMatch = (school['keywords'] as List<String>)
            .any((keyword) => keyword.toLowerCase().contains(searchTerm));
        return distance <= _searchRadius &&
            (searchTerm.isEmpty || nameMatch || keywordMatch);
      }).toList();

      _recommendedSchools = _filteredSchools.take(5).toList();
      _updateMarkers();
    });
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _filterSchools();
    });
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // in kilometers
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * asin(sqrt(a));
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  void _updateMarkers() {
    _markers.clear();
    for (var school in _filteredSchools) {
      _markers.add(
        Marker(
          markerId: MarkerId(school['name']),
          position: LatLng(school['latitude'], school['longitude']),
          infoWindow: InfoWindow(
            title: school['name'],
            onTap: () => _selectSchool(school),
          ),
        ),
      );
    }
    if (_selectedLocation != null) {
      _markers.add(
        Marker(
          markerId: MarkerId('current_location'),
          position: _selectedLocation!,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          infoWindow: InfoWindow(title: 'Current Location'),
        ),
      );
    }
  }

  void _selectSchool(Map<String, dynamic> school) {
    Navigator.of(context).pop({
      'location': LatLng(school['latitude'], school['longitude']),
      'name': school['name'],
    });
  }

  Future<void> _onMapTap(LatLng location) async {
    setState(() {
      _selectedLocation = location;
      _updateMarkers();
    });

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address = '${place.name}, ${place.locality}, ${place.country}';
        
        // Immediately return the custom location
        Navigator.of(context).pop({
          'location': location,
          'name': address,
        });
      } else {
        // If no address found, return generic "Custom Location"
        Navigator.of(context).pop({
          'location': location,
          'name': 'Custom Location',
        });
      }
    } catch (e) {
      print('Error getting address: $e');
      // If there's an error, still return the location
      Navigator.of(context).pop({
        'location': location,
        'name': 'Custom Location',
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select School Location'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomTextFormField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              hintText: 'Search schools',
              prefixIcon: Icon(Icons.search),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  _filterSchools();
                },
              ),
              borderRadius: 30,
              fillColor: Colors.grey[200],
              onChange: _onSearchChanged,
              textInputType: TextInputType.text,
              textInputAction: TextInputAction.search,
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _selectedLocation ?? widget.initialLocation,
                    zoom: 12,
                  ),
                  onMapCreated: (controller) => _mapController = controller,
                  markers: _markers,
                  circles: {
                    Circle(
                      circleId: CircleId('searchArea'),
                      center: _selectedLocation ?? widget.initialLocation,
                      radius: _searchRadius * 1000, // Convert km to meters
                      fillColor: Colors.blue.withOpacity(0.1),
                      strokeColor: Colors.blue,
                      strokeWidth: 1,
                    ),
                  },
                  onTap: _onMapTap,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
                if (_isLoading) Center(child: CircularProgressIndicator()),
                if (_errorMessage.isNotEmpty)
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      color: Colors.red.withOpacity(0.8),
                      child: Text(
                        _errorMessage,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                if (_showTip)
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: _buildTipCard(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard() {
    return AnimatedOpacity(
      opacity: _showTip ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      child: Dismissible(
        key: Key('tip'),
        onDismissed: (_) {
          setState(() {
            _showTip = false;
          });
        },
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.amber[100]!, Colors.amber[200]!],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -20,
                    top: -20,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.amber[300]!.withOpacity(0.3),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.amber[300],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.lightbulb_outline,
                              color: Colors.white),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Can't find your school?",
                                style: GoogleFonts.plusJakartaSans(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "You can select a custom location on the map!",
                                style: GoogleFonts.plusJakartaSans(
                                  textStyle: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.amber[800]),
                          onPressed: () {
                            setState(() {
                              _showTip = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}