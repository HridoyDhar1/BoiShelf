
import 'package:book/navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widget/custom_button.dart';
import '../../../../core/widget/custom_textfield.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});
static const String name='resetpass';
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}
final TextEditingController passwordController=TextEditingController();
final TextEditingController confrimPasswordController=TextEditingController();
class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Reset Your Password",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Vulputate massa in libero diam commodo lorem platea sagittis lectus. Volutpat tristique enim risus blandit sit.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 40),
                CustomTextFormFields(controller:passwordController,hintText: 'Enter New password',isPassword: true, valid: 'Please enter password',),
                const SizedBox(height: 20),
                CustomTextFormFields(controller:confrimPasswordController,hintText: 'Confirm Password',isPassword: true, valid: 'Please enter password again',),
                const SizedBox(height: 20),
                CustomElevatedButton(buttonName: 'Reset Now', onPressed: () {
                  Get.toNamed(CustomNavigationScreen.name);
                },),
                const SizedBox(height: 10),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
