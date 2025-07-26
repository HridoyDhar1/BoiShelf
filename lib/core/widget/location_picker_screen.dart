//
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
//
// class LocationPickerScreen extends StatefulWidget {
//   const LocationPickerScreen({super.key});
//
//   @override
//   State<LocationPickerScreen> createState() => _LocationPickerScreenState();
// }
//
// class _LocationPickerScreenState extends State<LocationPickerScreen> {
//   GoogleMapController? _mapController;
//   LatLng? _pickedLocation;
//   String _address = "";
//
//   Future<void> _getUserLocation() async {
//     final permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied) return;
//
//     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     _mapController?.animateCamera(CameraUpdate.newLatLngZoom(LatLng(position.latitude, position.longitude), 15));
//     _setLocation(LatLng(position.latitude, position.longitude));
//   }
//
//   Future<void> _setLocation(LatLng location) async {
//     setState(() {
//       _pickedLocation = location;
//     });
//
//     List<Placemark> placemarks = await placemarkFromCoordinates(location.latitude, location.longitude);
//     if (placemarks.isNotEmpty) {
//       final place = placemarks.first;
//       setState(() {
//         _address = "${place.street}, ${place.locality}, ${place.country}";
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _getUserLocation();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Pick Location")),
//       body: Stack(
//         children: [
//           GoogleMap(
//             initialCameraPosition: const CameraPosition(
//               target: LatLng(23.8103, 90.4125), // Default: Dhaka
//               zoom: 12,
//             ),
//             onMapCreated: (controller) => _mapController = controller,
//             onTap: _setLocation,
//             markers: _pickedLocation != null
//                 ? {
//               Marker(
//                 markerId: const MarkerId("picked"),
//                 position: _pickedLocation!,
//               )
//             }
//                 : {},
//           ),
//           if (_address.isNotEmpty)
//             Positioned(
//               bottom: 80,
//               left: 20,
//               right: 20,
//               child: Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Text(_address, style: const TextStyle(fontSize: 16)),
//                 ),
//               ),
//             ),
//         ],
//       ),
//       floatingActionButton: _pickedLocation != null
//           ? FloatingActionButton.extended(
//         onPressed: () {
//           Navigator.pop(context, _address);
//         },
//         label: const Text("Select Location"),
//         icon: const Icon(Icons.check),
//       )
//           : null,
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? _mapController;
  LatLng? _pickedLocation;
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
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

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

      final LatLng currentLatLng = LatLng(position.latitude, position.longitude);

      setState(() {
        _isLoading = false;
        _pickedLocation = currentLatLng;
      });

      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(currentLatLng, 15),
        );
      }

      await _setLocation(currentLatLng);
    } catch (e) {
      print("Error fetching location: $e");
      setState(() {
        _isLoading = false;
        _pickedLocation = const LatLng(22.3569, 91.7832); // Chittagong fallback
      });
      await _setLocation(_pickedLocation!);
    }
  }

  Future<void> _setLocation(LatLng location) async {
    setState(() {
      _pickedLocation = location;
    });

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          _address = "${place.street}, ${place.locality}, ${place.country}";
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
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _pickedLocation ?? const LatLng(22.3569, 91.7832),
              zoom: 15,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
              if (_pickedLocation != null) {
                _mapController!.animateCamera(
                  CameraUpdate.newLatLngZoom(_pickedLocation!, 15),
                );
              }
            },
            onTap: _setLocation,
            markers: _pickedLocation != null
                ? {
              Marker(
                markerId: const MarkerId("picked"),
                position: _pickedLocation!,
              )
            }
                : {},
          ),
          if (_address.isNotEmpty)
            Positioned(
              bottom: 80,
              left: 20,
              right: 20,
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    _address,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: _pickedLocation != null
          ? FloatingActionButton.extended(
        onPressed: () {
          Navigator.pop(context, _address);
        },
        label: const Text("Select Location"),
        icon: const Icon(Icons.check),
      )
          : null,
    );
  }
}
