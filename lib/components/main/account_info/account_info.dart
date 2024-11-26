import 'dart:io';

import 'package:amphi/models/app.dart';
import 'package:amphi/models/app_localizations.dart';
import 'package:amphi/models/user.dart';
import 'package:amphi/widgets/dialogs/confirmation_dialog.dart';
import 'package:amphi/widgets/profile_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/channels/app_method_channel.dart';
import 'package:notes/channels/app_web_channel.dart';
import 'package:notes/channels/app_web_sync.dart';
import 'package:notes/components/main/account_info/account_item.dart';
import 'package:notes/components/main/account_info/change_password_dialog.dart';
import 'package:notes/components/main/list_view/linear_item_border.dart';
import 'package:notes/models/app_settings.dart';
import 'package:notes/models/app_state.dart';
import 'package:notes/models/app_storage.dart';
import 'package:notes/models/note.dart';
import 'package:notes/views/login_view.dart';
import 'package:notes/views/login_view_dialog.dart';

class AccountInfo extends StatefulWidget {
  const AccountInfo({super.key});

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  List<User> unselectedUsers = [];
  late TextEditingController usernameController = TextEditingController(
      text: appWebChannel.token.isNotEmpty ? appStorage.selectedUser.name : AppLocalizations.of(context).get("@guest"));
  bool editingUsername = false;
  bool sendingRequest = false;
  String? errorMessage = null;

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    appWebChannel.userNameUpdateListeners.add((name) {
      setState(() {
        usernameController.text = name;
      });
    });
    for (User user in appStorage.users) {
      if (user.storagePath != appStorage.selectedUser.storagePath) {
        unselectedUsers.add(user);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (value, data) {
        if (Platform.isAndroid) {
          appMethodChannel.setNavigationBarColor(Theme.of(context).scaffoldBackgroundColor, appSettings.transparentNavigationBar);
        }
      },
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 2),
        child: Column(
          children: [
            GestureDetector(
                onTap: () {
                  print(appWebChannel.token);
                },
                child: ProfileImage(size: 100, fontSize: 50, user: appStorage.selectedUser, token: appWebChannel.token)),
            SizedBox(
              width: 175,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 100,
                      child: TextField(
                        readOnly: !editingUsername,
                        controller: usernameController,
                        textAlign: TextAlign.center,
                        style: TextStyle(),
                        decoration: InputDecoration(
                            border: editingUsername ? null : InputBorder.none, focusedBorder: editingUsername ? null : InputBorder.none),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: Visibility(
                      visible: appWebChannel.token.isNotEmpty,
                      child: IconButton(
                          icon: Icon(editingUsername ? Icons.check : Icons.edit),
                          onPressed: () {
                            if (editingUsername) {
                              setState(() {
                                sendingRequest = true;
                                errorMessage = null;
                              });
                            } else {
                              setState(() {
                                sendingRequest = false;
                                errorMessage = null;
                              });
                            }
                            if (editingUsername && usernameController.text != appStorage.selectedUser.name) {
                              appWebChannel.changeUsername(
                                  name: usernameController.text,
                                  onSuccess: () {
                                    appState.notifySomethingChanged(() {
                                      sendingRequest = false;
                                      errorMessage = null;
                                      appStorage.selectedUser.name = usernameController.text;
                                      appStorage.saveSelectedUserInformation();
                                    });
                                  },
                                  onFailed: (statusCode) {
                                    if (statusCode == HttpStatus.unauthorized) {
                                      setState(() {
                                        sendingRequest = false;
                                        errorMessage = AppLocalizations.of(context).get("@failed_to_auth");
                                      });
                                    } else if (statusCode == null) {
                                      setState(() {
                                        sendingRequest = false;
                                        errorMessage = AppLocalizations.of(context).get("@failed_to_connect");
                                      });
                                    }
                                  });
                            }
                            setState(() {
                              editingUsername = !editingUsername;
                            });
                          }),
                    ),
                  )
                ],
              ),
            ),
            Visibility(
              visible: appWebChannel.token.isNotEmpty,
              child: TextButton(
                child: Text(
                  AppLocalizations.of(context).get("@change_password"),
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return ChangePasswordDialog();
                      });
                },
              ),
            ),
            Visibility(
                visible: appWebChannel.token.isEmpty,
                child: TextButton(
                  child: Text(
                    AppLocalizations.of(context).get("@login"),
                  ),
                  onPressed: () {
                    if (App.isWideScreen(context)) {
                      showDialog(context: context, builder: (context) => LoginViewDialog());
                    } else {
                      Navigator.push(context, CupertinoPageRoute(builder: (context) => LoginView()));
                    }
                  },
                )),
            Visibility(
              visible: unselectedUsers.isNotEmpty,
              child: TextButton(
                child: Text(
                  AppLocalizations.of(context).get("@remove_user"),
                ),
                onPressed: () {
                  if (unselectedUsers.isNotEmpty) {
                    showConfirmationDialog("@dialog_title_remove_user", () {
                      Navigator.popUntil(
                        context,
                        (Route<dynamic> route) => route.isFirst,
                      );
                      appStorage.removeUser(() {
                        appStorage.saveSelectedUser(unselectedUsers[0]);
                        appStorage.users.remove(appStorage.selectedUser);
                        appStorage.selectedUser = unselectedUsers[0];

                        appStorage.initPaths();
                        appState.notifySomethingChanged(() {
                          appStorage.initNotes();
                        });
                      });
                    });
                  }
                },
              ),
            ),
            Visibility(visible: sendingRequest, child: CircularProgressIndicator()),
            Visibility(visible: errorMessage != null, child: Text(errorMessage ?? "", style: TextStyle(color: Theme.of(context).highlightColor))),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: ListView.separated(
                    itemCount: unselectedUsers.length + 1,
                    shrinkWrap: true,
                    separatorBuilder: (c, d) {
                      return Divider(
                        color: Theme.of(context).dividerColor,
                        height: 0,
                      );
                    },
                    itemBuilder: (context, index) {
                      LinearItemBorder linearItemBorder = LinearItemBorder(index: index, length: unselectedUsers.length + 1, context: context);
                      if (index < unselectedUsers.length) {
                        return AccountItem(
                            icon: ProfileImage(size: 30, fontSize: 20, user: unselectedUsers[index], token: appWebChannel.token),
                            linearItemBorder: linearItemBorder,
                            title: unselectedUsers[index].name.isEmpty ? AppLocalizations.of(context).get("@guest") : unselectedUsers[index].name,
                            onPressed: () async {
                              Navigator.popUntil(
                                context,
                                (Route<dynamic> route) => route.isFirst,
                              );
                              await appStorage.saveSelectedUser(unselectedUsers[index]);
                              appStorage.selectedUser = unselectedUsers[index];
                              appStorage.initPaths();
                              appSettings.getData();
                              appWebChannel.disconnectWebSocket();
                              appWebChannel.connectWebSocket();

                              appState.noteEditingController.setNote(Note.createdNote(""));
                              appState.notifySomethingChanged(() {
                                appStorage.initNotes();
                                appWebChannel.syncDataFromEvents();
                              });
                            });
                      } else {
                        return AccountItem(
                            icon: Icon(Icons.account_circle, size: 30),
                            linearItemBorder: linearItemBorder,
                            title: AppLocalizations.of(context).get("@add_account"),
                            onPressed: () {
                              setState(() {
                                appStorage.addUser(onFinished: (user) async {
                                  Navigator.popUntil(
                                    context,
                                    (Route<dynamic> route) => route.isFirst,
                                  );
                                  await appStorage.saveSelectedUser(user);
                                  appStorage.selectedUser = user;
                                  appStorage.users.add(user);
                                  appStorage.initPaths();
                                  appSettings.getData();
                                  appWebChannel.disconnectWebSocket();
                                  appState.noteEditingController.setNote(Note.createdNote(""));
                                  appState.notifySomethingChanged(() {
                                    appStorage.initNotes();
                                  });
                                });
                              });
                            });
                      }
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
