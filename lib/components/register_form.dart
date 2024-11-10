import 'package:flutter/material.dart';
import 'package:notes/channels/app_web_channel.dart';
import 'package:notes/components/login_input.dart';
import 'package:amphi/models/app_localizations.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {

  TextEditingController usernameController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  late List<String> userIds;
  List<String> ids = [];
  bool sendingRequest = false;
  String? errorMessage = null;

  void textListener() {
    setState(() {

    });
  }

  @override
  void dispose() {
    confirmPasswordController.removeListener(textListener);
    idController.removeListener(textListener);
    usernameController.dispose();
    idController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    confirmPasswordController.addListener(textListener);
    idController.addListener(textListener);
    appWebChannel.getUserIds(onResponse: (list) {
      ids = list;
    }, onFailed: () {

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                AppLocalizations.of(context).get("@welcome"),
                style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
              child: LoginInput(
                textEditingController: usernameController,
                hint: AppLocalizations.of(context).get("@hint_username"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
              child: LoginInput(
                textEditingController: idController,
                hint: AppLocalizations.of(context).get("@hint_id"),
              ),
            ),
            Visibility(
              visible: ids.contains(idController.text),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                  child: Text(
                    AppLocalizations.of(context).get("@id_already_taken"),
                    style: TextStyle(
                        color: Theme.of(context).primaryColor
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
              child: LoginInput(
                textEditingController: passwordController,
                hint: AppLocalizations.of(context).get("@hint_password"),
                obscureText: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
              child: LoginInput(
                textEditingController: confirmPasswordController,
                hint: AppLocalizations.of(context).get("@hint_confirm_password"),
                obscureText: true,
              ),
            ),
            Visibility(
              visible: passwordController.text != confirmPasswordController.text,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                  child: Text(
                    AppLocalizations.of(context).get("@hint_password_different"),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
                visible: sendingRequest,
                child: CircularProgressIndicator()),
            Visibility(
                visible: errorMessage != null,
                child: Text(errorMessage ?? "", style: TextStyle(color: Theme.of(context).highlightColor))),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
                    elevation: 5,
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    )
                ),
                child: Text(
                  AppLocalizations.of(context).get("@register"),
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).floatingActionButtonTheme.focusColor,
                  ),
                ),
                onPressed: () {

                  if(passwordController.text == confirmPasswordController.text && !ids.contains(idController.text) && passwordController.text.isNotEmpty && usernameController.text.isNotEmpty && idController.text.isNotEmpty) {
                    appWebChannel.register(id: idController.text, name: usernameController.text, password: passwordController.text, onRegistered: () {
                      Navigator.pop(context);
                    }, onFailed: (message) {
                      setState(() {
                        sendingRequest = false;
                        errorMessage = AppLocalizations.of(context).get("@failed_to_auth");
                      });
                    });
                  }
                },
              ),
            ),
          ]

      ),
    );
  }
}
