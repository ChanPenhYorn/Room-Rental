import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dwellly_flutter/core/theme/app_theme.dart';

class LocationPickerScreen extends StatefulWidget {
  final int userId;

  const LocationPickerScreen({
    super.key,
    required this.userId,
  });

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  String? _address;
  bool _isLoadingAddress = false;
  bool _isLoading = true;
  Position? _currentPosition;
  Timer? _geocodingTimer;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location services are disabled')),
        );
      }
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')),
          );
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permissions are permanently denied'),
          ),
        );
      }
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
    debugPrint('DEBUG: [LocationPicker] current position: $position');
    setState(() {
      _currentPosition = position;
      _selectedLocation = LatLng(position.latitude, position.longitude);
      _isLoading = false;
    });
    debugPrint(
      'DEBUG: [LocationPicker] Initialized selected location: $_selectedLocation',
    );
    _updateAddress(_selectedLocation!);
  }

  Future<void> _updateAddress(LatLng location) async {
    if (location.latitude == 0 && location.longitude == 0) {
      return;
    }

    debugPrint('DEBUG: [LocationPicker] Updating address for: $location');

    setState(() {
      _isLoadingAddress = true;
    });
    try {
      final placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final parts = <String>[];
        if (place.street != null && place.street!.isNotEmpty) {
          parts.add(place.street!);
        }
        if (place.locality != null && place.locality!.isNotEmpty) {
          parts.add(place.locality!);
        }
        if (place.administrativeArea != null &&
            place.administrativeArea!.isNotEmpty) {
          parts.add(place.administrativeArea!);
        }
        setState(() {
          _address = parts.join(', ');
        });
      }
    } catch (e) {
      debugPrint('DEBUG: [LocationPicker] geocoding failed for $location: $e');
      setState(() {
        _address = null;
      });
    } finally {
      setState(() {
        _isLoadingAddress = false;
      });
    }
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _selectedLocation = position.target;
    });
    _geocodingTimer?.cancel();
    _geocodingTimer = Timer(const Duration(milliseconds: 800), () {
      _updateAddress(position.target);
    });
  }

  void _recenter() {
    if (_currentPosition != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        ),
      );
    }
  }

  void _sendLocation() {
    if (_selectedLocation == null) return;
    Navigator.pop(context, {
      'latitude': _selectedLocation!.latitude,
      'longitude': _selectedLocation!.longitude,
      'address': _address ?? 'Unknown location',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppTheme.primaryBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Share Location',
          style: GoogleFonts.outfit(
            color: AppTheme.primaryBlack,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _selectedLocation != null ? _sendLocation : null,
            child: Text(
              'Send',
              style: GoogleFonts.outfit(
                color: _selectedLocation != null
                    ? AppTheme.primaryGreen
                    : AppTheme.secondaryGray,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_isLoading)
            const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: AppTheme.primaryGreen,
                  ),
                  SizedBox(height: 16),
                  Text('Getting your location...'),
                ],
              ),
            )
          else
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _selectedLocation ?? const LatLng(11.5, 104.8),
                zoom: 15,
              ),
              onMapCreated: (controller) {
                _mapController = controller;
              },
              onCameraMove: _onCameraMove,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
            ),
          if (!_isLoading)
            Center(
              child: Transform.translate(
                offset: const Offset(0, -24),
                child: const Icon(
                  Icons.location_pin,
                  color: AppTheme.primaryGreen,
                  size: 48,
                ),
              ),
            ),
          if (!_isLoading)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_isLoadingAddress)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.primaryGreen,
                          ),
                        )
                      else if (_address != null)
                        Text(
                          _address!,
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: AppTheme.primaryBlack,
                          ),
                          textAlign: TextAlign.center,
                        )
                      else
                        Text(
                          'Select a location',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: AppTheme.secondaryGray,
                          ),
                        ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          if (!_isLoading)
            Positioned(
              right: 16,
              bottom: 120,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: Colors.white,
                onPressed: _recenter,
                child: const Icon(
                  Icons.my_location,
                  color: AppTheme.primaryGreen,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
