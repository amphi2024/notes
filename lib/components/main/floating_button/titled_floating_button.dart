import 'package:flutter/material.dart';
import 'package:notes/components/main/floating_button/floating_button.dart';

class TitledFloatingButton extends StatelessWidget {

  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  const TitledFloatingButton({super.key, required this.title, required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
            margin: const EdgeInsets.all(10),
            child: Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15))),
        FloatingButton(
          icon: icon,
          onPressed: onPressed,
        ),
      ],
    );
  }
}
