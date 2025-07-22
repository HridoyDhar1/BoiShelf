import 'package:assignment/core/constants/app_images.dart';
import 'package:assignment/core/wigets/custom_button.dart';
import 'package:assignment/core/wigets/custom_navigation.dart';
import 'package:assignment/core/wigets/custom_text_form_fields.dart';
import 'package:assignment/feature/auth/presentation/screens/forget_password_screen.dart';
import 'package:assignment/feature/auth/presentation/screens/singup_screen.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';


class LoginScreen extends StatefulWidget {
  static const String name = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.themeColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AssetImages.appLogo,height: 300,width: 200,),
        
                const SizedBox(height: 40),
          CustomTextFormFields(controller: emailController, labelText: "Mail Address",suffixIcon: Icon(Icons.email,color: Colors.white,),),
                const SizedBox(height: 20),
               CustomTextFormFields(controller:passwordController,labelText: 'Password',isPassword: true),
                const SizedBox(height: 20),
                CustomElevatedButton(buttonName: 'Login', onPressed: () { Get.toNamed(CustomNavigationScreen.name); },),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      Get.toNamed(ForgetPasswordScreen.name);
                    },
                    child: const Text(
                      "Forgot Password",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    text: "Don’t have an account? ",
                    style: const TextStyle(color: Colors.white),
                    children: [
                      TextSpan(
                        text: "Sign Up",
                        style: const TextStyle(
                          color: AppColors.accentColor,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.toNamed(SingUpScreen.name);
                          },
                      ),
                    ],
                  ),
                ),
        
              ],
            ),
          ),
        ),
      ),
    );
  }
}

