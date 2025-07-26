import 'dart:io';

import 'package:book/feature/Auth/presentation/screen/create_profile.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constant/app_color.dart';
import '../../../../core/widget/custom_button.dart';
import '../../../../core/widget/custom_passwordfield.dart';

import '../../../../core/widget/custom_textfield.dart';
import '../../../../core/widget/location_picker_screen.dart';
import '../../../../core/widget/soial_icon.dart';

import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  static const String name = '/signup';

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController locationController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  File? _selectedImage;
  String? _imageUrl;
  final ImagePicker _picker = ImagePicker();

  Future<void> signUpUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Create user with email and password
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      // Use the user's UID as the Document ID to store their data
      await _firestore.collection("Users").doc(userCredential.user!.uid).set({
        "name": fullNameController.text.trim(),
        "email": emailController.text.trim(),
        "uid": userCredential.user!.uid,
        "location": locationController.text.trim(),
        "createdAt": FieldValue.serverTimestamp(), // Optional: add a timestamp
      });

      // Navigate to profile creation screen or home screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreateProfileScreen()),
      );
    } catch (e) {
      // ignore: avoid_print
      print("Signup Error: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Text("SingUp", style: TextStyle(fontSize: 30)),
                const SizedBox(height: 50),

                CustomTextFormFields(
                  controller: fullNameController,
                  hintText: "Full Name",
                  prefixIcon: Icon(Icons.person), valid: 'Enter the name',
                ),
                const SizedBox(height: 10),
                CustomTextFormFields(
                  controller: emailController,

                  hintText: "Email",
                  prefixIcon: Icon(Icons.email), valid: 'Enter the email',
                ),
                const SizedBox(height: 10),
                CustomTextFormFields(
                  controller: locationController,
                  hintText: "Location",
                  prefixIcon: IconButton(
                    icon: Icon(Icons.location_on),
                    onPressed: () async {
                      final selectedLocation = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LocationPickerScreen(),
                        ),
                      );

                      if (selectedLocation != null) {
                        locationController.text = selectedLocation;
                      }
                    },
                  ),
                  valid: 'Please select your location',
                ),

                const SizedBox(height: 10),

                CustomPasswordField(
                  hintText: "Password",
                  valid: "Enter password",
                  controller: passwordController,
                  icons: Icons.lock,
                  surfixIcons: Icons.visibility,
                  keyboard: TextInputType.text,
                ),
                const SizedBox(height: 10),
                CustomPasswordField(
                  hintText: "Confirm password",
                  valid: "Confirm password",

                  controller: confirmPasswordController,
                  icons: Icons.lock,
                  surfixIcons: Icons.visibility,
                  keyboard: TextInputType.text,
                ),
                const SizedBox(height: 50),
                _isLoading
                    ? CircularProgressIndicator()
                    : CustomElevatedButton(
                        buttonName: "Sign Up",
                        onPressed: onTapNextButton,
                      ),

                const SizedBox(height: 20),
                Divider(),
                Center(
                  child: Column(
                    children: [
                      const Text(
                        "Or Sign Up with",
                        style: TextStyle(color: Colors.black87),
                      ),
                      const SizedBox(height: 10),
                      const SocialIcons(),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: const TextStyle(color: Colors.black87),
                      children: [
                        TextSpan(
                          text: "Login",
                          style: TextStyle(color: AppColors.accentColor),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.toNamed(LoginScreen.name);
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onTapNextButton() {
    if (_formKey.currentState?.validate() ?? false) {
      if (passwordController.text != confirmPasswordController.text) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Passwords do not match!")));
        return;
      }
      signUpUser();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields ")),
      );
    }
  }
}
