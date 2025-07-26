// import 'dart:io';
// import 'package:book/feature/sell/data/book_condition.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
// import '../widget/drop_down.dart';
// import '../widget/text_field.dart';
// import '../widget/submit_button.dart';
//
// class SellBookScreen extends StatefulWidget {
//   static const String name = '/sell_book';
//   const SellBookScreen({super.key});
//
//   @override
//   _SellBookScreenState createState() => _SellBookScreenState();
// }
//
// class _SellBookScreenState extends State<SellBookScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _bookNameController = TextEditingController();
//   final TextEditingController _priceController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _locationController = TextEditingController();
//   final TextEditingController _conditionController = TextEditingController();
//
//   String? _selectedCondition;
//   List<File> _bookImages = [];
//
//   // Add book condition detector
//   final BookConditionDetector _conditionDetector = BookConditionDetector();
//   bool _isDetectorLoaded = false;
//   bool _isAnalyzing = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeConditionDetector();
//   }
//
//   @override
//   void dispose() {
//     _conditionDetector.dispose();
//     super.dispose();
//   }
//
//   /// Initialize the book condition detector
//   Future<void> _initializeConditionDetector() async {
//     try {
//       _isDetectorLoaded = await _conditionDetector.loadModel();
//       if (_isDetectorLoaded) {
//         print('Book condition detector loaded successfully');
//       } else {
//         print('Failed to load book condition detector');
//       }
//     } catch (e) {
//       print('Error initializing condition detector: $e');
//       _isDetectorLoaded = false;
//     }
//   }
//   void _openMap(BuildContext context) async {
//     final selectedAddress = await Navigator.push<String>(
//       context,
//       MaterialPageRoute(builder: (_) => const MapScreen()),
//     );
//
//     if (selectedAddress != null && mounted) {
//       setState(() {
//         _locationController.text = selectedAddress;
//       });
//     }
//   }
//
//
//   Future<void> _pickMultipleImages() async {
//     try {
//       final result = await FilePicker.platform.pickFiles(
//         type: FileType.image,
//         allowMultiple: true,
//       );
//       if (result != null) {
//         setState(() {
//           _bookImages = result.paths.map((path) => File(path!)).toList();
//         });
//       }
//     } catch (_) {}
//   }
//
// Future<void> _analyzeImageText() async {
//     if (_bookImages.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select at least one image')),
//       );
//       return;
//     }
//
//     setState(() {
//       _isAnalyzing = true;
//     });
//
//     try {
//       // Text recognition (existing functionality)
//       final inputImage = InputImage.fromFile(_bookImages[0]);
//       final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
//       final RecognizedText recognizedText =
//       await textRecognizer.processImage(inputImage);
//       await textRecognizer.close();
//
//       final lines = recognizedText.text.split('\n');
//       String? title;
//       String? author;
//
//       for (var line in lines) {
//         if (title == null && line.trim().length > 3) {
//           title = line.trim();
//         } else if (author == null && line.trim().length > 3) {
//           author = line.trim();
//           break;
//         }
//       }
//
//       if (title != null) _bookNameController.text = title;
//
//       // Book condition detection (new functionality)
//       String detectedCondition = 'Unknown';
//       double confidence = 0.0;
//
//       if (_isDetectorLoaded) {
//         try {
//           final conditionResult = await _conditionDetector.detectConditionFromFile(_bookImages[0]);
//           if (conditionResult != null) {
//             detectedCondition = conditionResult.condition;
//             confidence = conditionResult.confidence;
//
//             // Automatically fill the condition text field
//             setState(() {
//               _conditionController.text = detectedCondition;
//             });
//           }
//         } catch (e) {
//           print('Error detecting book condition: $e');
//           detectedCondition = 'Detection Failed';
//         }
//       } else {
//         detectedCondition = 'Detector Not Available';
//       }
//
//       setState(() {
//         _isAnalyzing = false;
//       });
//
//       showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//           title: const Text('Analysis Results'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('📘 Title: ${title ?? "Not found"}'),
//               const SizedBox(height: 8),
//               Text('✍️ Author: ${author ?? "Not found"}'),
//               const SizedBox(height: 8),
//               const Divider(),
//               const SizedBox(height: 8),
//               Text('📊 Book Condition: $detectedCondition'),
//               if (confidence > 0)
//                 Text('🎯 Confidence: ${(confidence * 100).toStringAsFixed(1)}%'),
//               const SizedBox(height: 8),
//               if (detectedCondition != 'Unknown' && detectedCondition != 'Detection Failed' && detectedCondition != 'Detector Not Available')
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: detectedCondition.toLowerCase() == 'good'
//                         ? Colors.green.withOpacity(0.1)
//                         : Colors.orange.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(
//                       color: detectedCondition.toLowerCase() == 'good'
//                           ? Colors.green
//                           : Colors.orange,
//                     ),
//                   ),
//                   child: Text(
//                     'Condition automatically filled in the form',
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: detectedCondition.toLowerCase() == 'good'
//                           ? Colors.green[700]
//                           : Colors.orange[700],
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('OK')
//             ),
//           ],
//         ),
//       );
//     } catch (e) {
//       setState(() {
//         _isAnalyzing = false;
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Analysis error: ${e.toString()}')),
//       );
//     }
//   }
//   Future<void> submit() async {
//     if (!_formKey.currentState!.validate() || _bookImages.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please complete the form and select images")),
//       );
//       return;
//     }
//
//     try {
//       final firestore = FirebaseFirestore.instance;
//       final storage = FirebaseStorage.instance;
//       final currentUser = FirebaseAuth.instance.currentUser;
//
//       if (currentUser == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("User not logged in")),
//         );
//         return;
//       }
//
//       final uid = currentUser.uid;
//
//       // Fetch user's name and profile image from Profile collection
//       final userProfileDoc =
//       await firestore.collection('Profile').doc(uid).get();
//
//       final profileData = userProfileDoc.data();
//       final posterName = profileData?['name'] ?? 'Unknown';
//       final posterPhotoUrl = profileData?['image_url'] ?? '';
//
//       // Upload images to Firebase Storage
//       List<String> imageUrls = [];
//
//       for (int i = 0; i < _bookImages.length; i++) {
//         final file = _bookImages[i];
//         final fileName = 'books/${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
//         final ref = storage.ref().child(fileName);
//         await ref.putFile(file);
//         final url = await ref.getDownloadURL();
//         imageUrls.add(url);
//       }
//
//       // Save post with user info to Firestore
//       await firestore.collection('books').add({
//         'uid': uid,
//         'username': posterName,
//         'user_photo': posterPhotoUrl,
//         'book_name': _bookNameController.text.trim(),
//         'price': double.parse(_priceController.text.trim()),
//         'condition': _conditionController.text.trim(),
//         'category': _selectedCondition,
//         'description': _descriptionController.text.trim(),
//         'location': _locationController.text.trim(),
//         'images': imageUrls,
//         'createdAt': FieldValue.serverTimestamp(),
//       });
//
//       // Reset form
//       _formKey.currentState!.reset();
//       setState(() {
//         _bookImages.clear();
//         _bookNameController.clear();
//         _priceController.clear();
//         _conditionController.clear();
//         _descriptionController.clear();
//         _locationController.clear();
//         _selectedCondition = null;
//       });
//
//       Get.toNamed("/navigation");
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Book listed successfully!")),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: ${e.toString()}")),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.white,
//         title: const Center(child: Text('Sell Your Book')),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               GestureDetector(
//                 onTap: _pickMultipleImages,
//                 child: _bookImages.isEmpty
//                     ? Container(
//                   height: 150,
//                   decoration: BoxDecoration(color: Colors.grey[300]),
//                   child: const Center(child: Text('Tap to select book images')),
//                 )
//                     : SizedBox(
//                   height: 150,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: _bookImages.length,
//                     itemBuilder: (context, index) => Padding(
//                       padding: const EdgeInsets.only(right: 8.0),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(8),
//                         child: Image.file(
//                           _bookImages[index],
//                           width: 120,
//                           height: 150,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               CustomTextField(
//                 controller: _bookNameController,
//                 label: 'Book Name',
//                 validator: (value) => value!.isEmpty ? 'Please enter book name' : null,
//               ),
//               const SizedBox(height: 12),
//               CustomTextField(
//                 controller: _priceController,
//                 label: 'Price',
//                 inputType: TextInputType.number,
//                 validator: (value) => value!.isEmpty ? 'Please enter price' : null,
//               ),
//               const SizedBox(height: 12),
//                TextFormField(
//                 controller: _conditionController,
//                 decoration: InputDecoration(
//                   prefixIcon: const Icon(Icons.assessment),
//                   labelText: "Condition",
//                   hintText: "Will be auto-filled after analysis",
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                   suffixIcon: _isDetectorLoaded
//                       ? Icon(Icons.smart_toy, color: Colors.green[600])
//                       : Icon(Icons.warning, color: Colors.orange[600]),
//                 ),
//                 validator: (value) => value!.isEmpty ? 'Please enter condition' : null,
//               ),
//               const SizedBox(height: 12),
//               TextFormField(
//                 controller: _locationController,
//                 readOnly: true,
//                 onTap: () => _openMap(context),
//                 decoration: InputDecoration(
//                   prefixIcon: const Icon(Icons.location_on),
//                   labelText: "Location",
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                 ),
//                 validator: (value) => value!.isEmpty ? 'Please select a location' : null,
//               ),
//               const SizedBox(height: 12),
//               Expanded(
//                 child: CustomDropdownField(
//                   label: 'Categories',
//                   items: [
//                     'Novels & Short Stories',
//                     'Science Fiction & Fantasy',
//                     'Literary Fiction & Poetry',
//                     'History',
//                     'Philosophy',
//                     'Biographies',
//                     'Academic Textbooks & Competitive‑Exam Guides',
//                     'Motivation',
//                     'Religious',
//                     'Children’s & Young Adult',
//                     'Folk & Oral Traditions',
//                     'Comics & Graphic Novels',
//                   ],
//                   value: _selectedCondition,
//                   onChanged: (val) => setState(() => _selectedCondition = val),
//                   validator: (value) => value == null ? 'Please select category' : null,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               TextFormField(
//                 controller: _descriptionController,
//                 maxLines: 5,
//                 decoration: InputDecoration(
//                   prefixIcon: const Icon(Icons.description),
//                   labelText: "Description",
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                 ),
//                 validator: (value) => value!.isEmpty ? 'Please enter description' : null,
//               ),
//               const SizedBox(height: 20),
//               SubmitButtonRow(onAnalyze: _analyzeImageText, onSubmit: submit),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class MapScreen extends StatefulWidget {
//   const MapScreen({super.key});
//
//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }
//
// class _MapScreenState extends State<MapScreen> {
//   LatLng? _currentLatLng;
//
//   @override
//   void initState() {
//     super.initState();
//     _setInitialLocation();
//   }
//
//   Future<void> _setInitialLocation() async {
//     try {
//       final position = await _getCurrentLocation();
//       setState(() {
//         _currentLatLng = LatLng(position.latitude, position.longitude);
//       });
//     } catch (e) {
//       setState(() {
//         _currentLatLng = const LatLng(23.8103, 90.4125); // fallback to Dhaka
//       });
//     }
//   }
//
//   Future<Position> _getCurrentLocation() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       await Geolocator.openLocationSettings();
//       throw Exception('Location services are disabled.');
//     }
//
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         throw Exception('Location permissions are denied.');
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       throw Exception('Location permissions are permanently denied.');
//     }
//
//     return await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.best);
//   }
//
//   String _formatAddress(Placemark p) {
//     return [
//       p.name,
//       p.street,
//       p.subLocality,
//       p.locality,
//       p.subAdministrativeArea,
//       p.administrativeArea,
//       p.country,
//       p.postalCode,
//     ].where((e) => e != null && e.isNotEmpty).join(', ');
//   }
//
//   void _onConfirm() async {
//     if (_currentLatLng == null) return;
//
//     try {
//       final placemarks = await placemarkFromCoordinates(
//         _currentLatLng!.latitude,
//         _currentLatLng!.longitude,
//       );
//
//       if (placemarks.isNotEmpty) {
//         final address = _formatAddress(placemarks.first);
//         Navigator.pop(context, address);
//       } else {
//         Navigator.pop(context,
//             '${_currentLatLng!.latitude}, ${_currentLatLng!.longitude}');
//       }
//     } catch (e) {
//       Navigator.pop(context,
//           '${_currentLatLng!.latitude}, ${_currentLatLng!.longitude}');
//     }
//   }
//
//   void _onTap(LatLng latLng) {
//     setState(() {
//       _currentLatLng = latLng;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_currentLatLng == null) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }
//
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
//       body: GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: _currentLatLng!,
//           zoom: 15,
//         ),
//         onTap: _onTap,
//         myLocationEnabled: true,
//         markers: {
//           Marker(
//             markerId: const MarkerId('selected-location'),
//             position: _currentLatLng!,
//           ),
//         },
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:book/feature/sell/data/book_condition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../widget/drop_down.dart';
import '../widget/text_field.dart';
import '../widget/submit_button.dart';

class SellBookScreen extends StatefulWidget {
  static const String name = '/sell_book';
  const SellBookScreen({super.key});

  @override
  _SellBookScreenState createState() => _SellBookScreenState();
}

class _SellBookScreenState extends State<SellBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _bookNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _conditionController = TextEditingController();

  String? _selectedCondition;
  List<File> _bookImages = [];

  LatLng? _selectedLatLng; // <-- Added to hold coordinates

  // Add book condition detector
  final BookConditionDetector _conditionDetector = BookConditionDetector();
  bool _isDetectorLoaded = false;
  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    _initializeConditionDetector();
  }

  @override
  void dispose() {
    _conditionDetector.dispose();
    super.dispose();
  }

  /// Initialize the book condition detector
  Future<void> _initializeConditionDetector() async {
    try {
      _isDetectorLoaded = await _conditionDetector.loadModel();
      if (_isDetectorLoaded) {
        print('Book condition detector loaded successfully');
      } else {
        print('Failed to load book condition detector');
      }
    } catch (e) {
      print('Error initializing condition detector: $e');
      _isDetectorLoaded = false;
    }
  }

  void _openMap(BuildContext context) async {
    final selectedLatLng = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(builder: (_) => const MapScreen()),
    );

    if (selectedLatLng != null && mounted) {
      setState(() {
        _selectedLatLng = selectedLatLng;
      });

      // Convert lat/lng to address string
      try {
        final placemarks = await placemarkFromCoordinates(
          selectedLatLng.latitude,
          selectedLatLng.longitude,
        );
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          final address = [
            p.name,
            p.street,
            p.locality,
            p.administrativeArea,
            p.country
          ].where((e) => e != null && e.isNotEmpty).join(', ');
          _locationController.text = address;
        } else {
          _locationController.text =
          '${selectedLatLng.latitude}, ${selectedLatLng.longitude}';
        }
      } catch (e) {
        _locationController.text =
        '${selectedLatLng.latitude}, ${selectedLatLng.longitude}';
      }
    }
  }

  Future<void> _pickMultipleImages() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );
      if (result != null) {
        setState(() {
          _bookImages = result.paths.map((path) => File(path!)).toList();
        });
      }
    } catch (_) {}
  }

  Future<void> _analyzeImageText() async {
    if (_bookImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one image')),
      );
      return;
    }

    setState(() {
      _isAnalyzing = true;
    });

    try {
      // Text recognition (existing functionality)
      final inputImage = InputImage.fromFile(_bookImages[0]);
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText =
      await textRecognizer.processImage(inputImage);
      await textRecognizer.close();

      final lines = recognizedText.text.split('\n');
      String? title;
      String? author;

      for (var line in lines) {
        if (title == null && line.trim().length > 3) {
          title = line.trim();
        } else if (author == null && line.trim().length > 3) {
          author = line.trim();
          break;
        }
      }

      if (title != null) _bookNameController.text = title;

      // Book condition detection (new functionality)
      String detectedCondition = 'Unknown';
      double confidence = 0.0;

      if (_isDetectorLoaded) {
        try {
          final conditionResult =
          await _conditionDetector.detectConditionFromFile(_bookImages[0]);
          if (conditionResult != null) {
            detectedCondition = conditionResult.condition;
            confidence = conditionResult.confidence;

            // Automatically fill the condition text field
            setState(() {
              _conditionController.text = detectedCondition;
            });
          }
        } catch (e) {
          print('Error detecting book condition: $e');
          detectedCondition = 'Detection Failed';
        }
      } else {
        detectedCondition = 'Detector Not Available';
      }

      setState(() {
        _isAnalyzing = false;
      });

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Analysis Results'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('📘 Title: ${title ?? "Not found"}'),
              const SizedBox(height: 8),
              Text('✍️ Author: ${author ?? "Not found"}'),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              Text('📊 Book Condition: $detectedCondition'),
              if (confidence > 0)
                Text('🎯 Confidence: ${(confidence * 100).toStringAsFixed(1)}%'),
              const SizedBox(height: 8),
              if (detectedCondition != 'Unknown' &&
                  detectedCondition != 'Detection Failed' &&
                  detectedCondition != 'Detector Not Available')
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: detectedCondition.toLowerCase() == 'good'
                        ? Colors.green.withOpacity(0.1)
                        : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: detectedCondition.toLowerCase() == 'good'
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ),
                  child: Text(
                    'Condition automatically filled in the form',
                    style: TextStyle(
                      fontSize: 12,
                      color: detectedCondition.toLowerCase() == 'good'
                          ? Colors.green[700]
                          : Colors.orange[700],
                    ),
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
          ],
        ),
      );
    } catch (e) {
      setState(() {
        _isAnalyzing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Analysis error: ${e.toString()}')),
      );
    }
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate() || _bookImages.isEmpty || _selectedLatLng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete the form, select images, and choose a location")),
      );
      return;
    }

    try {
      final firestore = FirebaseFirestore.instance;
      final storage = FirebaseStorage.instance;
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User not logged in")),
        );
        return;
      }

      final uid = currentUser.uid;

      // Fetch user's name and profile image from Profile collection
      final userProfileDoc = await firestore.collection('Profile').doc(uid).get();

      final profileData = userProfileDoc.data();
      final posterName = profileData?['name'] ?? 'Unknown';
      final posterPhotoUrl = profileData?['image_url'] ?? '';

      // Upload images to Firebase Storage
      List<String> imageUrls = [];

      for (int i = 0; i < _bookImages.length; i++) {
        final file = _bookImages[i];
        final fileName = 'books/${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
        final ref = storage.ref().child(fileName);
        await ref.putFile(file);
        final url = await ref.getDownloadURL();
        imageUrls.add(url);
      }

      // Save post with user info and lat/lng to Firestore
      await firestore.collection('books').add({
        'uid': uid,
        'username': posterName,
        'user_photo': posterPhotoUrl,
        'book_name': _bookNameController.text.trim(),
        'price': double.parse(_priceController.text.trim()),
        'condition': _conditionController.text.trim(),
        'category': _selectedCondition,
        'description': _descriptionController.text.trim(),
        'location': _locationController.text.trim(),
        'latitude': _selectedLatLng!.latitude,    // <-- new
        'longitude': _selectedLatLng!.longitude,  // <-- new
        'images': imageUrls,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Reset form
      _formKey.currentState!.reset();
      setState(() {
        _bookImages.clear();
        _bookNameController.clear();
        _priceController.clear();
        _conditionController.clear();
        _descriptionController.clear();
        _locationController.clear();
        _selectedCondition = null;
        _selectedLatLng = null;  // reset selected lat/lng
      });

      Get.toNamed("/navigation");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Book listed successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Center(child: Text('Sell Your Book')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickMultipleImages,
                child: _bookImages.isEmpty
                    ? Container(
                  height: 150,
                  decoration: BoxDecoration(color: Colors.grey[300]),
                  child: const Center(child: Text('Tap to select book images')),
                )
                    : SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _bookImages.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _bookImages[index],
                          width: 120,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    CustomTextField(
                      controller: _bookNameController,
                      label: 'Book Name',
                      validator: (value) => value!.isEmpty ? 'Please enter book name' : null,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _priceController,
                      label: 'Price',
                      inputType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? 'Please enter price' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _conditionController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.assessment),
                        labelText: "Condition",
                        hintText: "Will be auto-filled after analysis",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        suffixIcon: _isDetectorLoaded
                            ? Icon(Icons.smart_toy, color: Colors.green[600])
                            : Icon(Icons.warning, color: Colors.orange[600]),
                      ),
                      validator: (value) => value!.isEmpty ? 'Please enter condition' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _locationController,
                      readOnly: true,
                      onTap: () => _openMap(context),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.location_on),
                        labelText: "Location",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (value) => value!.isEmpty ? 'Please select a location' : null,
                    ),
                    const SizedBox(height: 12),
                    CustomDropdownField(
                      label: 'Categories',
                      items: [
                        'Novels & Short Stories',
                        'Science Fiction & Fantasy',
                        'Literary Fiction & Poetry',
                        'History',
                        'Philosophy',
                        'Biographies',
                        'Academic Textbooks & Competitive‑Exam Guides',
                        'Motivation',
                        'Religious',
                        'Children’s & Young Adult',
                        'Folk & Oral Traditions',
                        'Comics & Graphic Novels',
                      ],
                      value: _selectedCondition,
                      onChanged: (val) => setState(() => _selectedCondition = val),
                      validator: (value) => value == null ? 'Please select category' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.description),
                        labelText: "Description",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (value) => value!.isEmpty ? 'Please enter description' : null,
                    ),
                    const SizedBox(height: 20),
                    SubmitButtonRow(onAnalyze: _analyzeImageText, onSubmit: submit),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Updated MapScreen to return LatLng instead of address string
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _currentLatLng;

  @override
  void initState() {
    super.initState();
    _setInitialLocation();
  }

  Future<void> _setInitialLocation() async {
    try {
      final position = await _getCurrentLocation();
      setState(() {
        _currentLatLng = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      setState(() {
        _currentLatLng = const LatLng(23.8103, 90.4125); // fallback to Dhaka
      });
    }
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
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

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  void _onConfirm() {
    if (_currentLatLng == null) return;

    Navigator.pop(context, _currentLatLng);
  }

  void _onTap(LatLng latLng) {
    setState(() {
      _currentLatLng = latLng;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentLatLng == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _onConfirm,
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentLatLng!,
          zoom: 15,
        ),
        onTap: _onTap,
        myLocationEnabled: true,
        markers: {
          Marker(
            markerId: const MarkerId('selected-location'),
            position: _currentLatLng!,
          ),
        },
      ),
    );
  }
}
