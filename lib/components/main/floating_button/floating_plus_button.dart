import 'package:flutter/material.dart';
import 'package:notes/components/main/floating_button/floating_button.dart';
import 'package:notes/models/icons.dart';

class FloatingPlusButton extends StatelessWidget {

  final bool showing;
  final bool rotated;
  final void Function() onPressed;

  const FloatingPlusButton({super.key, required this.showing, required this.rotated, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 750),
      curve: Curves.easeOutQuint,
      right: showing ? 20 : -120,
      bottom: 20,
      child: AnimatedRotation(
        duration: const Duration(milliseconds: 1250),
        curve: Curves.easeOutQuint,
        turns: rotated ? -0.125 : 0,
        child: FloatingButton(
          icon: AppIcons.plus,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
