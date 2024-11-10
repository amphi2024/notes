import 'package:flutter/material.dart';
import 'package:notes/components/login_form.dart';
import 'package:amphi/models/app_localizations.dart';
import 'package:notes/models/icons.dart';

class LoginView extends StatelessWidget {

  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:  AppBar(
        leadingWidth: AppLocalizations.of(context).get("@login").length * 20 + 50,
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
                  Text(AppLocalizations.of(context).get("@login"))
                ],
              ),
            ),
          ],
        ),
      ),
      body: LoginForm(),
    );
  }
}

