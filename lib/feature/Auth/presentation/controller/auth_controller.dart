
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../../navigation.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxBool isLoading = false.obs;

  Future<void> signUpUser({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      Get.snackbar("ত্রুটি","পাসওয়ার্ড মিলছে না!",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;
    try {
      // Create user with email and password
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Use the user's UID as the Document ID to store their data
      await _firestore.collection("Users").doc(userCredential.user!.uid).set({
        "name": fullName.trim(),
        "email": email.trim(),
        "uid": userCredential.user!.uid,
        "createdAt": FieldValue.serverTimestamp(),  // Optional: add a timestamp
      });

      // Navigate to profile creation screen or home screen
      // Get.to(() => CreateProfileScreen());
    } catch (e) {
      Get.snackbar("Signup Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ User Login Function (Modify if needed)
  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Fetch user data from Firestore based on UID
      DocumentSnapshot userDoc = await _firestore
          .collection('Users')
          .doc(userCredential.user!.uid)
          .get();

      // You can now use userDoc data (e.g., userDoc['name'], userDoc['email'])

      Get.snackbar("সফল", "লগইন সফল হয়েছে",
          snackPosition: SnackPosition.BOTTOM);

      // Navigate to the home screen
      Get.offAllNamed(CustomNavigationScreen.name);
    } catch (e) {
      Get.snackbar("লগইন ত্রুটি", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }}
