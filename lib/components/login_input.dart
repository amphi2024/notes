import 'package:flutter/material.dart';

class LoginInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hint;
  final bool obscureText;
  const LoginInput({super.key, required this.textEditingController, required this.hint, this.obscureText = false});

  @override
  Widget build(BuildContext context) {

    return TextField(
      controller: textEditingController,
      obscureText: obscureText,
      decoration: InputDecoration(
          hintText: hint,
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  style: BorderStyle.solid,
                  width: 2),
              borderRadius: BorderRadius.circular(10)
          ),
          border: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(10)
          )
      ),

    );
  }
}