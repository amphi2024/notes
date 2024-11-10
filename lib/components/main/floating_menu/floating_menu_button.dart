import 'package:flutter/material.dart';

class FloatingMenuButton extends StatelessWidget {

  final IconData icon;
  final VoidCallback onPressed;
  const FloatingMenuButton({super.key, required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
            size: 30));
  }
}
