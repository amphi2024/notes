import 'package:flutter/material.dart';

class FloatingMenuDivider extends StatelessWidget {
  const FloatingMenuDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      decoration: BoxDecoration(color: Theme.of(context).dividerColor),
    );
  }
}
