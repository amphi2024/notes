import 'package:amphi/models/user.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../channels/app_web_channel.dart';
import '../models/app_settings.dart';
import '../models/app_storage.dart';
import 'data_sync.dart';

void onUserRemoved(WidgetRef ref) {
  appSettings.data = {};
  appWebChannel.disconnectWebSocket();
  // appStorage.initPaths();
  appSettings.getData();
  appWebChannel.getServerVersion(onSuccess: (version) {
    if(!version.startsWith("2.")) {
      appWebChannel.uploadBlocked = true;
    }
  }, onFailed: (code) {
    appWebChannel.uploadBlocked = true;
  });
  appWebChannel.connectWebSocket();
  refreshDataWithServer(ref);
}

void onUserAdded(WidgetRef ref) {
  appSettings.data = {};
  appWebChannel.disconnectWebSocket();
  // appStorage.initPaths();
  appSettings.getData();
  refreshDataWithServer(ref);
}

void onUsernameChanged(WidgetRef ref) {

}

void onSelectedUserChanged(User user, WidgetRef ref) {
  appWebChannel.getServerVersion(onSuccess: (version) {
    if(!version.startsWith("2.")) {
      appWebChannel.uploadBlocked = true;
    }
  }, onFailed: (code) {
    appWebChannel.uploadBlocked = true;
  });
  appSettings.data = {};
  appWebChannel.disconnectWebSocket();
  // appStorage.initPaths();
  appSettings.getData();
  refreshDataWithServer(ref);
}

void onLoggedIn({required String id, required String token, required String username, required BuildContext context,required WidgetRef ref}) async {
  appWebChannel.getServerVersion(onSuccess: (version) {
    if(!version.startsWith("2.")) {
      appWebChannel.uploadBlocked = true;
    }
  }, onFailed: (code) {
    appWebChannel.uploadBlocked = true;
  });
  appStorage.selectedUser.id = id;
  Navigator.popUntil(
    context,
        (Route<dynamic> route) => route.isFirst,
  );
  appStorage.selectedUser.name = username;
  appStorage.selectedUser.token = token;
  await appStorage.saveSelectedUserInformation();
  refreshDataWithServer(ref);
}