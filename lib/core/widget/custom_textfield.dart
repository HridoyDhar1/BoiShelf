import 'package:flutter/material.dart';

import '../constant/app_color.dart';


class CustomTextFormFields extends StatefulWidget {
  const CustomTextFormFields({
    super.key,
    required this.controller,
    this.hintText,
    this.isPassword = false,
    this.suffixIcon, this.prefixIcon, required this.valid,

  });
final Widget?prefixIcon;
  final String valid;
  final TextEditingController controller;
  final String? hintText;
  final bool isPassword;
  final Widget? suffixIcon;

  @override
  State<CustomTextFormFields> createState() => _CustomTextFormFieldsState();
}

class _CustomTextFormFieldsState extends State<CustomTextFormFields> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator:(value) {
        if (value == null || value.trim().isEmpty) {
          return widget.valid;
        }
        return null;
      } ,
      controller: widget.controller,
      obscureText: widget.isPassword && !_isPasswordVisible,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        prefixIcon:widget.prefixIcon ,
       hintText: widget.hintText,
        labelStyle: const TextStyle(color: Colors.black87),
        filled: false,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black87),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black87),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.themeColor, width: 2),
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        )
            : widget.suffixIcon,
      ),
    );
  }
}
