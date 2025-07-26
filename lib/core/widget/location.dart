import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final MapController _mapController = MapController();
  LatLng _pickedLocation = LatLng(22.3569, 91.7832);
  String _address = "";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception('Location services are disabled.');

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied.');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      LatLng currentLatLng = LatLng(position.latitude, position.longitude);
      setState(() {
        _pickedLocation = currentLatLng;
        _isLoading = false;
      });

      _mapController.move(_pickedLocation, 16);
      await _setLocation(_pickedLocation);
    } catch (e) {
      print("Location error: $e");
      setState(() {
        _isLoading = false;
        _pickedLocation = LatLng(22.3569, 91.7832); // fallback
      });
      await _setLocation(_pickedLocation);
    }
  }

  Future<void> _setLocation(LatLng location) async {
    setState(() {
      _pickedLocation = location;
    });

    try {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(location.latitude, location.longitude);

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          _address =
          "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
        });
      }
    } catch (e) {
      print("Geocoding failed: $e");
      setState(() {
        _address = "Lat: ${location.latitude}, Lng: ${location.longitude}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pick Location")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: _pickedLocation,
              zoom: 15.0,
              onTap: (tapPosition, point) => _setLocation(point),
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _pickedLocation,
                    width: 60,
                    height: 60,
                    builder: (ctx) =>
                    const Icon(Icons.location_on, size: 40, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
          if (_address.isNotEmpty)
            Positioned(
              bottom: 80,
              left: 20,
              right: 20,
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    _address,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pop(context, _address),
        label: const Text("Select Location"),
        icon: const Icon(Icons.check),
      ),
    );
  }
}
