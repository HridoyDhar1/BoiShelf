import 'package:book/feature/Auth/presentation/screen/create_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widget/custom_passwordfield.dart';
import '../../../../core/widget/custom_textfield.dart';
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
  final TextEditingController confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;



  Future<void> signUpUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Create user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );


      // Use the user's UID as the Document ID to store their data
      await _firestore.collection("Users").doc(userCredential.user!.uid).set({
        "name": fullNameController.text.trim(),
        "email": emailController.text.trim(),
        "uid": userCredential.user!.uid,
        "createdAt": FieldValue.serverTimestamp(),  // Optional: add a timestamp
      });


      // Navigate to profile creation screen or home screen
Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateProfileScreen()));

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
                const SizedBox(height: 100),
                Text("অ্যাকাউন্ট তৈরি করুন", style: TextStyle(fontSize: 30)),
                const SizedBox(height: 50),
                CustomTextField(text: "পুরো নাম ",
                    valid: "পুরো নাম লিখুন",
                    hintText: "পুরো নাম ",
                    controller: fullNameController,
                    icons: Icons.person,
                    keyboard: TextInputType.emailAddress),
                const SizedBox(height: 10),
                CustomTextField(
                  hintText: "ইমেল",
                  text: "ইমেল",
                  // FIXED
                  valid: "আপনার ইমেল লিখুন",
                  controller: emailController,
                  icons: Icons.email,
                  // FIXED ICON
                  keyboard: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                CustomPasswordField(
                  hintText: "পাসওয়ার্ড",
                  valid: "৮ সংখ্যার পাসওয়ার্ড লিখুন",
                  controller: passwordController,
                  icons: Icons.lock,
                  surfixIcons: Icons.visibility,
                  keyboard: TextInputType.text,
                ),
                const SizedBox(height: 10),
                CustomPasswordField(
                  hintText: "পাসওয়ার্ড",
                  valid: "আবার পাসওয়ার্ড লিখুন",
                  controller: confirmPasswordController,
                  icons: Icons.lock,
                  surfixIcons: Icons.visibility,
                  keyboard: TextInputType.text,
                ),
                const SizedBox(height: 50),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Color(0xff1B353C),
                  ),
                  onPressed: onTapNextButton,
                  child: Text("সাইন আপ", style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 20),
                Divider(),
                const SizedBox(height: 20),
                // SocialIcons(),
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "সাইন ইন",
                        style: TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {

                            Get.toNamed(LoginScreen.name);
                          },
                      ),
                    ],
                    text: "ইতিমধ্যেই একটি অ্যাকাউন্ট আছে!",
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Passwords do not match!")),
        );
        return;
      }
      signUpUser();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields correctly")),
      );
    }
  }

}
