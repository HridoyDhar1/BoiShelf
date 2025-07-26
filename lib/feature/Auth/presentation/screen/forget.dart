
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../../core/widget/custom_button.dart';
import '../../../../core/widget/custom_textfield.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
      body:
    SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 120),
            const Text(
              "Forget Password",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "No worries, we’ll send you reset instructions.",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 30),
            CustomTextFormFields(
              controller: forgetEmailController,
              hintText: 'Enter your mail address',
              suffixIcon: const Icon(Icons.email, color: Colors.black87), valid: 'Enter your email',
            ),


            const SizedBox(height: 20),
            CustomElevatedButton(
              buttonName: "Get Code",
              onPressed: () {
                Get.toNamed( "/verification");
              },
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    ),);
  }
}
