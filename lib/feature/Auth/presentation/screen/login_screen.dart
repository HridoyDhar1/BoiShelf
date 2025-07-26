


import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constant/app_color.dart';
import '../../../../core/constant/app_images.dart';
import '../../../../core/widget/custom_button.dart';
import '../../../../core/widget/custom_passwordfield.dart';

import '../../../../core/widget/soial_icon.dart';

import '../../../sell/presentation/widget/text_field.dart';
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(

          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(child: Image.asset(AssetImages.appLogoOne,height: 200,width: 200,)),
                //
                const SizedBox(height: 20),

                // Display message if no internet connection
                if (!isConnected)
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    color: Colors.redAccent,
                    child: const Text(
                      'No internet connection.Please turn on internet',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                const SizedBox(height: 20),

                CustomTextField(controller: emailOrPhoneController, label: "Email",prefixIcon: Icon(Icons.email),),
                const SizedBox(height: 20),
                CustomPasswordField(valid: "", controller: passwordController,         icons: Icons.lock,
                    surfixIcons: Icons.visibility,
                    hintText: "Password",
                    keyboard: TextInputType.text),
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
                const SizedBox(height: 20),
                CustomElevatedButton(buttonName: 'Login',         onPressed: () {
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
                        "Error",
                        "Please enter you email & password",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  } else {
                    // Show error snackbar if there's no internet connection
                    Get.snackbar(
                      "Error",
                      "No internet connection.Please turn on internet",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Get.toNamed("/forgetpassword");
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: RichText(

                    text: TextSpan(
                      text: "Don’t have an account? ",
                      style: const TextStyle(color: Colors.black87),
                      children: [
                        TextSpan(
                          text: "Sign Up",
                          style: const TextStyle(
                            color: AppColors.accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.toNamed("signup");
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
                const SocialIcons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
