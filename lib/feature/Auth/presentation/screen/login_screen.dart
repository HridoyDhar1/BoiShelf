

import 'package:book/feature/Auth/presentation/screen/signup_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widget/custom_passwordfield.dart';
import '../../../../core/widget/custom_textfield.dart';
import '../controller/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String name = '/login';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController emailOrPhoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  bool showNewPasswordField = false;
  bool isConnected = true;
  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
  }

  // Check internet connection
  _checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isConnected = false;
      });
    } else {
      setState(() {
        isConnected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                Text(
                  "ধন্যবাদ,",
                  style: TextStyle(

                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "ফিরে আসার জন্য স্বাগতম!",
                  style: TextStyle(

                    color: Colors.black87,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                const SizedBox(height: 20),

                // Display message if no internet connection
                if (!isConnected)
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    color: Colors.redAccent,
                    child: const Text(
                      'ইন্টারনেট সংযোগ নেই। অনুগ্রহ করে ইন্টারনেটে সংযোগ করুন।',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                const SizedBox(height: 20),

                CustomTextField(
                  text: "text",
                  valid: "",
                  controller: emailOrPhoneController,
                  icons: Icons.email,
                  keyboard: TextInputType.text,
                  hintText: "ইমেইল",
                ),
                const SizedBox(height: 20),
                CustomPasswordField(
                  hintText: 'পাসওয়ার্ড',
                  valid: "",
                  controller: passwordController,
                  icons: Icons.lock,
                  surfixIcons: Icons.visibility,
                  keyboard: TextInputType.text,
                ),
                const SizedBox(height: 20),

                // Show new password field only after reset
                if (showNewPasswordField)
                  CustomPasswordField(
                    hintText: 'New Password',
                    valid: "Enter new password",
                    controller: newPasswordController,
                    icons: Icons.lock_outline,
                    keyboard: TextInputType.text,
                  ),
                const SizedBox(height: 10),

                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      // Get.toNamed(ForgetPasswordScreen.name);
                    },
                    child: const Text(
                      "পাসওয়ার্ড ভুলে গেছি?",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Color(0xff1B353C),
                    ),
                    onPressed: () {
                      if (isConnected) {
                        // Ensure email and password fields are not empty
                        if (emailOrPhoneController.text.isNotEmpty &&
                            passwordController.text.isNotEmpty) {
                          // Attempt to log the user in
                          authController.loginUser(
                            email: emailOrPhoneController.text,
                            password: passwordController.text,
                          );
                        } else {
                          // Show error snackbar if fields are empty
                          Get.snackbar(
                            "ত্রুটি",
                            "দয়া করে আপনার ইমেল এবং পাসওয়ার্ড লিখুন।",
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      } else {
                        // Show error snackbar if there's no internet connection
                        Get.snackbar(
                          "ত্রুটি",
                          "ইন্টারনেট সংযোগ নেই। অনুগ্রহ করে ইন্টারনেটে সংযোগ করুন।",
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },

                    child: Text(
                      "সাইন ইন",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "কোন অ্যাকাউন্ট নেই?",
                      style: const TextStyle(color: Colors.black87),
                      children: [
                        TextSpan(
                          text: " সাইন আপ",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                          recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                         Get.toNamed(SignupScreen.name);
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 20),

                /// Social Icons
                // const SocialIcons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
