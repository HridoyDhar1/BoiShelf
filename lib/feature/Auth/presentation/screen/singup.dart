import 'package:assignment/core/constants/app_colors.dart';
import 'package:assignment/core/wigets/custom_button.dart';
import 'package:assignment/core/wigets/custom_text_form_fields.dart';
import 'package:assignment/feature/auth/presentation/widgets/social_icon.dart';
import 'package:assignment/feature/home/presentation/screens/home_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SingUpScreen extends StatefulWidget {
  const SingUpScreen({super.key});
  static const String name = '/singup';

  @override
  State<SingUpScreen> createState() => _SingUpScreenState();
}

class _SingUpScreenState extends State<SingUpScreen> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Sign Up",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Integer ultricies dolor enim id sed pulvinar sagittis in. Morbi venenatis nunc turpis morbi. Vitae ullamcorper vehicula praesent lorem.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 30),
              CustomTextFormFields(
                controller: userNameController,
                labelText: 'User Name',
                suffixIcon: const Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(height: 20),
              CustomTextFormFields(
                controller: mailController,
                labelText: 'Mail Address',
                suffixIcon: const Icon(Icons.email, color: Colors.white),
              ),
              const SizedBox(height: 20),
              CustomTextFormFields(
                controller: passwordController,
                labelText: 'Password',
                isPassword: true,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value ?? false;
                      });
                    },
                    activeColor: Colors.red, // Red when active
                    checkColor: Colors.white, // White checkmark
                  ),
                  const Expanded(
                    child: Text(
                      "I agree to the terms & conditions",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomElevatedButton(
                buttonName: "Sign Up",
                onPressed: () {
                Get.toNamed(HomeScrren.name);
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    const Text(
                      "Or Sign Up with",
                      style: TextStyle(color: Colors.white70),
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
                    style: const TextStyle(color: Colors.white),
                    children: [
                      TextSpan(
                        text: "Login",
                        style: TextStyle(color: AppColors.accentColor),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.toNamed('/login');
                          },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
