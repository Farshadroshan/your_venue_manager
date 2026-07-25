import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerScreen extends StatefulWidget {
  final double? initialLatitude;
  final double? initialLongitude;

  const LocationPickerScreen({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
  });

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  LatLng? selectedLocation;
  bool isLoading = true;
  String? errorMessage;

  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();

    if (widget.initialLatitude != null && widget.initialLongitude != null) {
      selectedLocation = LatLng(
        widget.initialLatitude!,
        widget.initialLongitude!,
      );
    }

    _loadCurrentLocation();
  }

  Future<void> _loadCurrentLocation() async {
    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        setState(() {
          isLoading = false;
          errorMessage = "Please enable location services.";
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        setState(() {
          isLoading = false;
          errorMessage = "Location permission was denied.";
        });
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          isLoading = false;
          errorMessage =
              "Location permission is permanently denied. "
              "Please enable it from settings.";
        });
        return;
      }

      if (selectedLocation == null) {
        final Position position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
        );

        selectedLocation = LatLng(position.latitude, position.longitude);
      }

      if (!mounted) {
        return;
      }

      setState(() {
        isLoading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        isLoading = false;
        errorMessage = "Could not load location: $error";
      });
    }
  }

  void _selectLocation(LatLng location) {
    setState(() {
      selectedLocation = location;
    });
  }

  void _confirmLocation() {
    final LatLng? location = selectedLocation;

    if (location == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a location on the map.")),
      );
      return;
    }

    Navigator.pop(context, location);
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify Venue Location")),
      body: _buildBody(),
      floatingActionButton: selectedLocation == null || isLoading
          ? null
          : FloatingActionButton.extended(
              onPressed: _confirmLocation,
              icon: const Icon(Icons.check),
              label: const Text("Confirm Location"),
            ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.location_off_outlined, size: 60),
              const SizedBox(height: 16),
              Text(errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: Geolocator.openAppSettings,
                child: const Text("Open Settings"),
              ),
            ],
          ),
        ),
      );
    }

    final LatLng location = selectedLocation ?? const LatLng(20.5937, 78.9629);

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(target: location, zoom: 16),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: false,
          onMapCreated: (controller) {
            mapController = controller;
          },
          onTap: _selectLocation,
          markers: {
            Marker(
              markerId: const MarkerId("venue_location"),
              position: location,
              draggable: true,
              onDragEnd: _selectLocation,
            ),
          },
        ),
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                "Tap the map or drag the marker to "
                "the exact venue location.\n"
                "Latitude: ${location.latitude.toStringAsFixed(6)}\n"
                "Longitude: ${location.longitude.toStringAsFixed(6)}",
              ),
            ),
          ),
        ),
      ],
    );
  }
}
