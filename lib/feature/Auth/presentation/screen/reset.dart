import 'package:assignment/core/constants/app_colors.dart';
import 'package:assignment/core/wigets/custom_button.dart';
import 'package:assignment/core/wigets/custom_text_form_fields.dart';
import 'package:assignment/feature/auth/presentation/screens/subscription_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      backgroundColor: AppColors.themeColor,
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
                CustomTextFormFields(controller:passwordController,labelText: 'Enter New password',isPassword: true),
                const SizedBox(height: 20),
                CustomTextFormFields(controller:confrimPasswordController,labelText: 'Confirm Password',isPassword: true),
                const SizedBox(height: 20),
                CustomElevatedButton(buttonName: 'Reset Now', onPressed: () {
                  Get.toNamed(SubscriptionScreen.name);
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
