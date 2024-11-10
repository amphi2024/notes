import 'package:flutter/material.dart';
import 'package:notes/components/register_form.dart';
import 'package:amphi/models/app_localizations.dart';
import 'package:notes/models/icons.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        leadingWidth: AppLocalizations.of(context).get("@register").length * 20 + 50,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    AppIcons.back,
                    size: 25,
                  ),
                  Text(AppLocalizations.of(context).get("@register"))
                ],
              ),
            ),
          ],
        ),
      ),
      body: RegisterForm(),
    );
  }
}
