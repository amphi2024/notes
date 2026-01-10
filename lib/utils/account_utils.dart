import 'package:amphi/models/user.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/database/database_helper.dart';
import 'package:notes/providers/editing_note_provider.dart';

import '../channels/app_web_channel.dart';
import '../models/app_settings.dart';
import '../models/app_storage.dart';
import '../providers/notes_provider.dart';
import '../providers/themes_provider.dart';
import 'data_sync.dart';

void onUserRemoved(WidgetRef ref) async {
  appWebChannel.disconnectWebSocket();
  appStorage.initPaths();
  await databaseHelper.notifySelectedUserChanged();
  await appSettings.getData();
  appWebChannel.getServerVersion(onSuccess: (version) {
    if (!version.startsWith("2.")) {
      appWebChannel.uploadBlocked = true;
    }
  }, onFailed: (code) {
    appWebChannel.uploadBlocked = true;
  });
  appWebChannel.connectWebSocket();
  refreshDataWithServer(ref);
  ref.read(notesProvider.notifier).rebuild();
  ref.read(themesProvider.notifier).rebuild();
  initEditingNote(ref);
}

void onUserAdded(WidgetRef ref) async {
  appWebChannel.disconnectWebSocket();
  appStorage.initPaths();
  await databaseHelper.notifySelectedUserChanged();
  await appSettings.getData();
  ref.read(notesProvider.notifier).rebuild();
  ref.read(themesProvider.notifier).rebuild();
  initEditingNote(ref);
}

void onUsernameChanged(WidgetRef ref) {
}

void onSelectedUserChanged(User user, WidgetRef ref) async {
  appWebChannel.getServerVersion(onSuccess: (version) {
    if (!version.startsWith("2.")) {
      appWebChannel.uploadBlocked = true;
    }
  }, onFailed: (code) {
    appWebChannel.uploadBlocked = true;
  });
  appWebChannel.disconnectWebSocket();
  appStorage.initPaths();
  await databaseHelper.notifySelectedUserChanged();
  await appSettings.getData();

  ref.read(notesProvider.notifier).rebuild();
  ref.read(themesProvider.notifier).rebuild();
  initEditingNote(ref);

  appWebChannel.connectWebSocket();
  refreshDataWithServer(ref);
}

void onLoggedIn({required String id, required String token, required String username, required BuildContext context, required WidgetRef ref}) async {
  appWebChannel.getServerVersion(onSuccess: (version) {
    if (!version.startsWith("2.")) {
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
