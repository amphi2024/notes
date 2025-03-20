import 'package:flutter/material.dart';
import 'package:notes/components/register_form.dart';
import 'package:notes/models/icons.dart';

class RegisterViewDialog extends StatelessWidget {
  const RegisterViewDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 250,
        height: 500,
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
              child: RegisterForm(),
            ),
          ],
        ),
      ),
    );
  }
}
