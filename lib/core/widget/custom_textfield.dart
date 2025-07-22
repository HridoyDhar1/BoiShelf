import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.text,
    required this.valid,
    required this.controller,
    required this.icons,
    this.hintText,
    this.surfixIcons,
    required this.keyboard,
    this.labelText,
    this.onChanged, // ✅ Add onChanged callback
  });

  final String text;
  final String valid;
  final TextEditingController controller;
  final IconData icons;
  final String? hintText;
  final String? labelText;
  final IconData? surfixIcons;
  final TextInputType keyboard;
  final Function(String)? onChanged; // ✅ Allow passing a function

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextFormField(
            controller: controller,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return valid;
              }
              return null;
            },
            keyboardType: keyboard,
            decoration: InputDecoration(
              labelText: labelText,
              hintText: hintText,
              prefixIcon: Icon(icons),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: onChanged, // ✅ Ensure this is triggered
          ),
        ],
      ),
    );
  }
}
