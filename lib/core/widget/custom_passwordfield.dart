import 'package:flutter/material.dart';

class CustomPasswordField extends StatefulWidget {
  const CustomPasswordField({
    super.key,

    required this.valid,
    required this.controller,
    required this.icons,
    this.hintText,
    this.labelText,
    this.surfixIcons,
    required this.keyboard,
  });

final String?labelText;
  final String valid;
  final TextEditingController controller;
  final IconData icons;
  final String? hintText;
  final IconData? surfixIcons;
  final TextInputType keyboard;

  @override
  _CustomPasswordFieldState createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Padding(
          padding: const EdgeInsets.all(2.0),
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.surfixIcons != null ? _obscureText : false,
            keyboardType: widget.keyboard,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String? value) {
              if (value==null ||value.isEmpty ) {
                return widget.valid;
              }
              if(value.length!=8){
                return "Enter 8 digit password";
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: widget.hintText,
              labelText: widget.labelText,
              prefixIcon: Icon(widget.icons),
              suffixIcon: widget.surfixIcons != null
                  ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
                  : null,
              border: OutlineInputBorder(

                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
