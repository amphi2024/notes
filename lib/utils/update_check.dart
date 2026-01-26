import 'dart:async';

import 'package:amphi/models/app_localizations.dart';
import 'package:amphi/utils/update_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:notes/utils/toast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../channels/app_web_channel.dart';
import '../models/app_cache_data.dart';
import '../models/app_settings.dart';

const appVersion = "2.1.0";

Future<void> checkForAppUpdate(BuildContext context) async {
  if (appCacheData.lastUpdateCheck.add(Duration(days: 2)).isBefore(DateTime.now()) && appSettings.autoCheckUpdate) {
    unawaited(checkForUpdate(
        url: "https://api.github.com/repos/amphi2024/notes/releases/latest",
        currentVersion: appVersion,
        onSuccess: () {
          appCacheData.lastUpdateCheck = DateTime.now();
          appCacheData.save();
        },
        onUpdateFound: (version) async {
          final clickedButton = await FlutterPlatformAlert.showCustomAlert(
            windowTitle: AppLocalizations.of(context).get("update_alert_title"),
            text: AppLocalizations.of(context).get("update_alert_text"),
            iconStyle: IconStyle.information,
            positiveButtonTitle: AppLocalizations.of(context).get("update_now"),
            negativeButtonTitle: AppLocalizations.of(context).get("update_later"),
          );

          if (clickedButton.name == "positiveButton") {
            launchUrl(Uri.parse("https://amphi.site/notes"));
          }
        }));
  }
}

Future<void> checkForServerUpdate(BuildContext context) async {
  if (appCacheData.lastServerUpdateCheck.add(Duration(days: 2)).isBefore(DateTime.now()) && appSettings.autoCheckServerUpdate) {
    appWebChannel.getServerVersion(onSuccess: (version) {
      unawaited(checkForUpdate(
          url: "https://api.github.com/repos/amphi2024/server/releases/latest",
          currentVersion: version,
          onSuccess: () {
            appCacheData.lastServerUpdateCheck = DateTime.now();
            appCacheData.save();
          },
          onUpdateFound: (latestVersion) async {
            showToast(context, AppLocalizations.of(context).get("server_update_message"));
          }));
    });
  }
}
