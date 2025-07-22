import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});
  static const String name = '/create_profile';

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController brithController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  String? selectGender;
  String? imageUrl;
  double? currentLat;
  double? currentLng;

  Future<void> _pickImage() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      setState(() {
        _selectedImage = imageFile;
      });

      try {
        String uid = FirebaseAuth.instance.currentUser!.uid;
        final ref =
        FirebaseStorage.instance.ref().child('user_images/$uid.jpg');
        await ref.putFile(imageFile);
        final url = await ref.getDownloadURL();
        setState(() {
          imageUrl = url;
        });
      } catch (e) {
        // Handle error
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission denied.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permission permanently denied.');
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        currentLat = position.latitude;
        currentLng = position.longitude;
      });

      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);
      Placemark place = placemarks[0];

      String address =
          "${place.street}, ${place.locality}, ${place.country}";
      locationController.text = address;

      Get.to(() => LocationMapScreen(lat: currentLat!, lng: currentLng!));
    } catch (e) {
      Get.snackbar("Location Error", e.toString(),
          backgroundColor: Colors.red.shade100);
    }
  }

  Future<void> saveUserProfile() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception("User not logged in");

      String? imageDownloadUrl;
      if (_selectedImage != null) {
        final ref =
        FirebaseStorage.instance.ref().child('user_images/$uid.jpg');
        await ref.putFile(_selectedImage!);
        imageDownloadUrl = await ref.getDownloadURL();
      }

      final userProfile = {
        'uid': uid,
        'name': fullNameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'gender': genderController.text.trim(),
        'birth': brithController.text.trim(),
        'location': locationController.text.trim(),
        'image_url': imageDownloadUrl ?? "",
        'createdAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('Profile')
          .doc(uid)
          .set(userProfile);

      Get.snackbar("Success", "Profile saved successfully",
          backgroundColor: Colors.green.shade100);

      Get.toNamed('/navigation');
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.red.shade100);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Center(
            child: Text("Create Profile",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              const SizedBox(height: 20),
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : null,
                    ),
                    GestureDetector(
                      onTap: _pickImage,
                      child: const CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.black,
                        child: Icon(Icons.camera_alt,
                            size: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField("Full name", fullNameController),
              Row(
                children: [
                  Expanded(
                      child: _buildTextField("Gender", genderController,
                          fieldType: 'dropdown')),
                  const SizedBox(width: 16),
                  Expanded(
                      child: _buildTextField("Birthday", brithController,
                          fieldType: 'date')),
                ],
              ),
              _buildTextField("Phone number", phoneController),
              _buildTextField("Email", emailController),
              _buildTextField("Location", locationController,
                  fieldType: 'location'),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: saveUserProfile,
                child: const Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {String? fieldType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 5),
          if (fieldType == 'dropdown')
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
              ),
              value: selectGender,
              items: ['Male', 'Female', 'Other']
                  .map((gender) =>
                  DropdownMenuItem(value: gender, child: Text(gender)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectGender = value!;
                  genderController.text = value;
                });
              },
            )
          else if (fieldType == 'date')
            TextFormField(
              controller: controller,
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime(2000),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  String formattedDate =
                      "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                  brithController.text = formattedDate;
                }
              },
              decoration: InputDecoration(
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
              ),
            )
          else if (fieldType == 'location')
              Stack(
                alignment: Alignment.centerRight,
                children: [
                  TextFormField(
                    controller: controller,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 10),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.location_on),
                    onPressed: _getCurrentLocation,
                  ),
                ],
              )
            else
              TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                ),
              ),
        ],
      ),
    );
  }
}

// Location Map Screen
class LocationMapScreen extends StatelessWidget {
  final double lat;
  final double lng;

  const LocationMapScreen({super.key, required this.lat, required this.lng});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Location")),
      body: GoogleMap(
        initialCameraPosition:
        CameraPosition(target: LatLng(lat, lng), zoom: 16),
        markers: {
          Marker(markerId: const MarkerId('marker'), position: LatLng(lat, lng))
        },
      ),
    );
  }
}
