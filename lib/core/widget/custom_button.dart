import 'package:flutter/material.dart';

import '../constant/app_color.dart';



class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.buttonName,
    required this.onPressed,
  });

  final String buttonName;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black87,
        fixedSize: const Size(double.maxFinite, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      child: Text(
        buttonName,
        style: const TextStyle(fontSize: 18,color: Colors.white),
      ),
    );
  }
}
