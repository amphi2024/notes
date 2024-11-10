import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notes/channels/app_method_channel.dart';
import 'package:notes/components/main/account_info/account_bottom_sheet.dart';
import 'package:notes/components/main/account_info/account_info.dart';
import 'package:amphi/models/app.dart';
import 'package:notes/models/app_settings.dart';
import 'package:notes/models/app_storage.dart';
import 'package:notes/models/icons.dart';
import 'package:amphi/widgets/profile_image.dart';

class AccountButton extends StatelessWidget {

  const AccountButton({super.key});

  @override
  Widget build(BuildContext context) {
    double iconSize = 30;
    double profileIconSize = 20;
    if(App.isWideScreen(context)) {
      iconSize = 20;
      profileIconSize = 15;
    }
    return IconButton(
        icon: ProfileImage(size: iconSize, fontSize: profileIconSize, user: AppStorage.getInstance().selectedUser),
        onPressed: () {
          if(App.isWideScreen(context)) {
            showDialog(context: context, builder:
                (context) {
              return Dialog(
                child: Container(
                  width: 250,
                  height: 500,
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
                      Expanded(child: AccountInfo())
                    ],
                  ),
                ),
              );
            });
          }
          else {
            if(Platform.isAndroid) {
              appMethodChannel.setNavigationBarColor(Theme.of(context).cardColor, appSettings.iosStyleUI);
            }
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return AccountBottomSheet();
              },
            );
          }
        });
  }
}
