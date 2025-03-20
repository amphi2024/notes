import 'package:flutter/material.dart';
import 'package:notes/components/login_form.dart';
import 'package:notes/models/icons.dart';
import 'package:notes/views/login_view.dart';

class LoginViewDialog extends LoginView {
  LoginViewDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 250,
        height: 400,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  icon: Icon(AppIcons.times),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
            SingleChildScrollView(
              child: LoginForm(),
            ),
          ],
        ),
      ),
    );
  }
}
