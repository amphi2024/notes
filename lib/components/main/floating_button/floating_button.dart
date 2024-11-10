import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const FloatingButton(
      {super.key,
      required this.icon,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 60.0,
        height: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor,
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
                shape: const CircleBorder()),
            onPressed: onPressed,
            icon: Icon(
              color: Theme.of(context).floatingActionButtonTheme.splashColor,
              icon,
              size: Theme.of(context).floatingActionButtonTheme.iconSize,
            )));
  }
}
