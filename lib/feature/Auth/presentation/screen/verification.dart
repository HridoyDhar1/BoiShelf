
import 'package:book/feature/Auth/presentation/screen/reset.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'dart:async';

import '../../../../core/constant/app_color.dart';
import '../../../../core/constant/app_texts.dart';
import '../../../../core/widget/custom_button.dart';

class VerificationCodeScreen extends StatefulWidget {
  const VerificationCodeScreen({super.key});
  static const String name = "/verification";

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final TextEditingController pinController = TextEditingController();

  final RxInt _remainingTime = AppConstants.reSendOtpTimeOutInSec.obs;
  final RxBool _enableResendCodeButton = false.obs;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    pinController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _remainingTime.value = AppConstants.reSendOtpTimeOutInSec;
    _enableResendCodeButton.value = false;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingTime.value > 0) {
        _remainingTime.value--;
      } else {
        _timer?.cancel();
        _enableResendCodeButton.value = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 120),
              const Text(
                "Enter Your Verification Code",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Sed varius eget arcu posuere varius tincidunt lectus. Eros justo sollicitudin egestas lorem ipsum. Bibendum.",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              PinCodeTextField(
                controller: pinController,
                maxLength: 4,
                defaultBorderColor: Colors.grey,
                pinBoxWidth: 60,
                pinBoxHeight: 60,
                pinBoxRadius: 12,
                pinBoxColor: Colors.black,
                pinBoxBorderWidth: 2,
                pinTextStyle: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              Obx(() {
                if (_remainingTime.value > 0) {
                  return RichText(
                    text: TextSpan(
                      text: 'This code will expire in ',
                      style: const TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(
                          text: '${_remainingTime.value}s',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Text(
                    "Code expired. Please request a new code.",
                    style: TextStyle(color: Colors.redAccent),
                  );
                }
              }),
              const SizedBox(height: 16),
              Obx(() {
                return Visibility(
                  visible: _enableResendCodeButton.value,
                  child: TextButton(
                    onPressed: () {
                      _startTimer();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Verification code resent.")),
                      );
                    },
                    child: const Text(
                      "Resend Code",
                      style: TextStyle(color: AppColors.themeColor),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),
              CustomElevatedButton(
                buttonName: "Verify Now",
                onPressed: () {
             Get.toNamed(ResetPasswordScreen.name);
                }
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
