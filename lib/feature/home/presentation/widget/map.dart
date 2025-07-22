import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final Position position;
  const MapScreen({required this.position, super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _controller;

  @override
  Widget build(BuildContext context) {
    final userLatLng = LatLng(widget.position.latitude, widget.position.longitude);

    return Scaffold(
      appBar: AppBar(title: const Text('My Location')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: userLatLng,
          zoom: 15,
        ),
        myLocationEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
      ),
    );
  }
}
