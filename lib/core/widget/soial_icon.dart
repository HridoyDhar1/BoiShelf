import 'package:flutter/material.dart';

class SocialIcons extends StatelessWidget {
  const SocialIcons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        socialIcon("assets/icon/facebook.png"),
        const SizedBox(width: 20),
        socialIcon('assets/icon/google.png'),

      ],
    );
  }
  Widget socialIcon(String assetName) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Center(
        child: Image.asset(
          assetName,
          width: 24,
          height: 24,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
