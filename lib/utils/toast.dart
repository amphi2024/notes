import 'package:flutter/material.dart';

void showToast(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Container(
      child: Text(content),
    ),
    behavior: SnackBarBehavior.floating,
    width: 250,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10)
    ),
    elevation: 15,
duration: Duration(milliseconds: 1500),
  ),
    snackBarAnimationStyle: AnimationStyle(curve: Curves.easeOutQuint, duration: Duration(milliseconds: 500),reverseCurve: Curves.easeOutQuint, reverseDuration: Duration(milliseconds: 500),)
  );
}
