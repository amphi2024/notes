import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/channels/app_web_channel.dart';
import 'package:notes/channels/app_web_sync.dart';
import 'package:notes/components/login_input.dart';
import 'package:amphi/models/app.dart';
import 'package:amphi/models/app_localizations.dart';
import 'package:notes/models/app_storage.dart';
import 'package:notes/views/register_view.dart';
import 'package:notes/views/register_view_dialog.dart';

class LoginForm extends StatefulWidget {

  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late int randomIndex;
  late String title;
  late List<String> titles;
   String? errorMessage = null;
  bool sendingRequest = false;

  @override
  void dispose() {
    idController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {

    Random random = Random();
    randomIndex = random.nextInt(3); // 3 is length of titles
    
    super.initState();
  }

  void onLoggedIn(String username, String token) async {
    appStorage.selectedUser.id = idController.text;
  Navigator.popUntil(
  context,
  (Route<dynamic> route) => route.isFirst,
  );
  appStorage.selectedUser.name = username;
  appStorage.selectedUser.token = token;
  await appStorage.saveSelectedUserInformation();
  appWebChannel.syncMissingFiles();
}

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
             children: [
              Builder(
                  builder: (context) {
                 titles = [
                   AppLocalizations.of(context).get("@who_are_you"),
                   AppLocalizations.of(context).get("@hello"),
                   AppLocalizations.of(context).get("@welcome"),
                 ];
                 String title = titles[randomIndex];
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        title,
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    );
                  }
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                child: LoginInput(
                  textEditingController: idController,
                  hint: AppLocalizations.of(context).get("@hint_id"),
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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
                    elevation: 5,
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    )
                ),
                child: Text(
                  AppLocalizations.of(context).get("@login"),
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                onPressed: () {
                  if(idController.text.isEmpty) {
                    setState(() {
                      errorMessage = AppLocalizations.of(context).get("@hint_input_id");
                      sendingRequest = false;
                    });
                  }
                  else if(passwordController.text.isEmpty) {
                    setState(() {
                      errorMessage = AppLocalizations.of(context).get("@hint_input_password");
                      sendingRequest = false;
                    });
                  }
                  else {
                    setState(() {
                      sendingRequest = true;
                    });
                    appWebChannel.login(
                        id: idController.text,
                        password: passwordController.text,
                        onLoggedIn: onLoggedIn,
                        onFailed: (statusCode) {
                          if(statusCode == HttpStatus.unauthorized) {
                            setState(() {
                              sendingRequest = false;
                              errorMessage = AppLocalizations.of(context).get("@failed_to_auth");
                            });
                          }
                          else if(statusCode == null) {
                            setState(() {
                              sendingRequest = false;
                              errorMessage = AppLocalizations.of(context).get("@connection_failed");
                            });
                          }
                        }
                    );
                  }

                },
              ),
              TextButton(onPressed: () {
                if(App.isWideScreen(context)) {
                  showDialog(context: context, builder: (context) {
                    return RegisterViewDialog();
                  });
                }
                else {
                  Navigator.push(context, CupertinoPageRoute(builder: (context) {
                    return RegisterView();
                  }));
                }
              }, child: Text(AppLocalizations.of(context).get("@register"))),
               Visibility(
                   visible: sendingRequest,
                   child: CircularProgressIndicator()),
               Visibility(
                 visible: errorMessage != null,
                   child: Text(errorMessage ?? "", style: TextStyle(color: Theme.of(context).primaryColor))),
               Visibility(
                   visible: appWebChannel.serverAddress.isEmpty,
                   child: Text(AppLocalizations.of(context).get("@please_set_server_address"), style: TextStyle(color: Theme.of(context).primaryColor), maxLines: 3,)),
            ]

        ),
    );
  }
}

