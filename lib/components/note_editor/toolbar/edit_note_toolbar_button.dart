import 'package:flutter/material.dart';

class EditNoteToolBarButton extends StatelessWidget {

  final IconData icon;
  final VoidCallback onPressed;
  const EditNoteToolBarButton({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 30,
        ));
  }
}
