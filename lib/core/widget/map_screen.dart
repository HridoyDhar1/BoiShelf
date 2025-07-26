// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:latlong2/latlong.dart';
//
// class MapScreen extends StatefulWidget {
//   const MapScreen({super.key});
//
//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }
//
// class _MapScreenState extends State<MapScreen> {
//   LatLng? selectedLatLng;
//   late final MapController _mapController;
//   bool isLoading = true;
//
//   final LatLng bangladeshCenter = const LatLng(23.8103, 90.4125);
//   final LatLngBounds bangladeshBounds = LatLngBounds(
//     LatLng(20.5, 88.0),
//     LatLng(26.6, 92.7),
//   );
//
//   @override
//   void initState() {
//     super.initState();
//     _mapController = MapController();
//     _getCurrentLocation();
//   }
//
//   Future<void> _getCurrentLocation() async {
//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) await Geolocator.openLocationSettings();
//
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) return;
//       }
//
//       final position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.best);
//
//       final latLng = LatLng(position.latitude, position.longitude);
//
//       if (bangladeshBounds.contains(latLng)) {
//         setState(() {
//           selectedLatLng = latLng;
//           isLoading = false;
//         });
//         _mapController.move(latLng, 14.5);
//       } else {
//         setState(() {
//           selectedLatLng = bangladeshCenter;
//           isLoading = false;
//         });
//         _mapController.move(bangladeshCenter, 13.0);
//       }
//     } catch (_) {
//       setState(() {
//         selectedLatLng = bangladeshCenter;
//         isLoading = false;
//       });
//     }
//   }
//
//   void _onMapTap(TapPosition tapPos, LatLng latLng) {
//     if (bangladeshBounds.contains(latLng)) {
//       setState(() => selectedLatLng = latLng);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text("Please select a location within Bangladesh.")),
//       );
//     }
//   }
//
//   String _formatAddress(Placemark p) {
//     return [
//       p.name,
//       p.street,
//       p.subLocality,
//       p.locality,
//       p.administrativeArea,
//       p.country,
//       p.postalCode,
//     ].where((e) => e != null && e.isNotEmpty).join(', ');
//   }
//
//   void _onConfirm() async {
//     if (selectedLatLng == null) return;
//
//     try {
//       final placemarks = await placemarkFromCoordinates(
//         selectedLatLng!.latitude,
//         selectedLatLng!.longitude,
//       );
//
//       final address = placemarks.isNotEmpty
//           ? _formatAddress(placemarks.first)
//           : '${selectedLatLng!.latitude}, ${selectedLatLng!.longitude}';
//
//       Navigator.pop(context, address);
//     } catch (_) {
//       Navigator.pop(context,
//           '${selectedLatLng!.latitude}, ${selectedLatLng!.longitude}');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Pick Location'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.check),
//             onPressed: _onConfirm,
//           ),
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : FlutterMap(
//         mapController: _mapController,
//         options: MapOptions(
//
//           maxZoom: 14.0,
//
//           onTap: _onMapTap,
//         ),
//         children: [
//           // Online or offline tile layer (see step 3 below)
//           TileLayer(
//             urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//             subdomains: const ['a', 'b', 'c'],
//           ),
//
//           // Show marker
//           if (selectedLatLng != null)
//             MarkerLayer(
//               markers: [
//                 Marker(
//                   width: 40,
//                   height: 40,
//                   point: selectedLatLng!,
//                   child:  const Icon(
//                     Icons.location_on,
//                     color: Colors.red,
//                     size: 40,
//                   ),
//                 ),
//               ],
//             ),
//         ],
//       ),
//     );
//   }
// }
