import 'package:assignment/core/wigets/custom_button.dart';
import 'package:assignment/core/wigets/custom_text_form_fields.dart';
import 'package:assignment/feature/auth/presentation/screens/verification_code_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});
static const String name="/forgetpassword";
  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}
final TextEditingController forgetEmailController=TextEditingController();
class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
    SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Forget Password",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "No worries, we’ll send you reset instructions.",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 30),
            CustomTextFormFields(
              controller: forgetEmailController,
              labelText: 'Enter your mail address',
              suffixIcon: const Icon(Icons.email, color: Colors.white),
            ),


            const SizedBox(height: 20),
            CustomElevatedButton(
              buttonName: "Get Code",
              onPressed: () {
                Get.toNamed(VerificationCodeScreen.name);
              },
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    ),);
  }
}
