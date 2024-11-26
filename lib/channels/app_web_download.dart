import 'dart:io';

import 'package:amphi/utils/path_utils.dart';
import 'package:http/http.dart';
import 'package:notes/channels/app_web_channel.dart';
import 'package:notes/models/app_storage.dart';
import 'package:notes/models/app_theme.dart';
import 'package:notes/models/folder.dart';
import 'package:notes/models/note.dart';

extension AppWebDownload on AppWebChannel {
  void downloadColors({void Function()? onSuccess, void Function()? onFailed}) async {
    try {
      final response = await get(
        Uri.parse("$serverAddress/notes/colors"),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', "Authorization": token},
      );

      if (response.statusCode == 200) {
        File file = File(appStorage.colorsPath);
        await file.writeAsBytes(response.bodyBytes);
        if (onSuccess != null) {
          onSuccess();
        }
      } else if (onFailed != null) {
        onFailed();
      }
    } catch (e) {
      if (onFailed != null) {
        onFailed();
      }
    }
  }

  Future<void> downloadNote({required String filename, void Function(Note note)? onSuccess, void Function()? onFailed}) async {
    try {
      final response = await get(
        Uri.parse("$serverAddress/notes/${filename}"),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', "Authorization": token},
      );
      if (response.statusCode == 200) {
        File file = File(PathUtils.join(appStorage.notesPath, filename));
        await file.writeAsBytes(response.bodyBytes);
        if (onSuccess != null) {
          onSuccess(Note.fromFile(file));
        }
      }
    } catch (e) {
      if (onFailed != null) {
        onFailed();
      }
    }
  }

  Future<void> downloadFolder({required String filename, void Function(Folder folder)? onSuccess, void Function()? onFailed}) async {
    try {
      final response = await get(
        Uri.parse("$serverAddress/notes/${filename}"),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', "Authorization": token},
      );
      if (response.statusCode == 200) {
        File file = File(PathUtils.join(appStorage.notesPath, filename));
        await file.writeAsBytes(response.bodyBytes);
        if (onSuccess != null) {
          onSuccess(Folder.fromFile(file));
        }
      }
    } catch (e) {
      if (onFailed != null) {
        onFailed();
      }
    }
  }

  void downloadImage(
      {required String noteFileNameOnly, required String imageFilename, void Function()? onSuccess, void Function()? onFailed}) async {
    try {
      final response = await get(
        Uri.parse("$serverAddress/notes/${noteFileNameOnly}/images/${imageFilename}"),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', "Authorization": token},
      );
      if (response.statusCode == 200) {
        File file = File(PathUtils.join(appStorage.notesPath, noteFileNameOnly, "images" ,imageFilename));
        await file.writeAsBytes(response.bodyBytes);
        if (onSuccess != null) {
          onSuccess();
        }
      }
    } catch (e) {
      if (onFailed != null) {
        onFailed();
      }
    }
  }

  void downloadVideo(
      {required String noteFileNameOnly, required String videoFilename, void Function()? onSuccess, void Function()? onFailed}) async {
    try {
      final response = await get(
        Uri.parse("$serverAddress/notes/${noteFileNameOnly}/videos/${videoFilename}"),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', "Authorization": token},
      );
      if (response.statusCode == 200) {
        File file = File(PathUtils.join(appStorage.notesPath, noteFileNameOnly, "videos" , videoFilename));
        await file.writeAsBytes(response.bodyBytes);
        if (onSuccess != null) {
          onSuccess();
        }
      }
    } catch (e) {
      if (onFailed != null) {
        onFailed();
      }
    }
  }

  void downloadTheme({required String filename, void Function(AppTheme)? onSuccess, void Function()? onFailed}) async {
    try {
      final response = await get(
        Uri.parse("$serverAddress/notes/themes/${filename}"),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', "Authorization": token},
      );
      if (response.statusCode == 200) {
        File file = File(PathUtils.join(appStorage.themesPath, filename));
        await file.writeAsBytes(response.bodyBytes);
        if (onSuccess != null) {
          onSuccess(AppTheme.fromFile(file));
        }
      }
    } catch (e) {
      if (onFailed != null) {
        onFailed();
      }
    }
  }
}
