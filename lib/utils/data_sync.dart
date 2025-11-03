import 'package:amphi/models/update_event.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/channels/app_web_channel.dart';
import 'package:notes/database/database_helper.dart';
import 'package:notes/models/app_storage.dart';
import 'package:notes/providers/notes_provider.dart';
import 'package:notes/providers/themes_provider.dart';

void refreshDataWithServer(WidgetRef ref) {
  appWebChannel.getNotes(onSuccess: (list) async {
    for (var item in list) {
      final id = item["id"];
      if (id is String) {
        final database = await databaseHelper.database;
        final List<Map<String, dynamic>> noteList = await database.rawQuery("SELECT * FROM notes WHERE id = ?", [id]);
        if(noteList.isEmpty) {
          await appWebChannel.downloadNote(id: id, onSuccess: (note) {
            note.save(upload: false);
            if(!note.isFolder) {
              note.initTitles();
            }
            ref.read(notesProvider.notifier).insertNote(note);
          });
        }
      }
    }
  });

  appWebChannel.getThemes(onSuccess: (list) async {
    for (var item in list) {
      final id = item["id"];
      if (id is String) {
        final database = await databaseHelper.database;
        final List<Map<String, dynamic>> themeList = await database.rawQuery("SELECT * FROM themes WHERE id = ?", [id]);
        if(themeList.isEmpty) {
          await appWebChannel.downloadTheme(id: id, onSuccess: (theme) {
            theme.save(upload: false);
            ref.read(themesProvider.notifier).insertTheme(theme);
          });
        }
      }
    }
  });
}

void syncDataWithServer(WidgetRef ref) {
  appWebChannel.getEvents(onResponse: (list) async {
    for (var updateEvent in list) {
      await applyUpdateEvent(updateEvent, ref);
    }
  });
}

Future<void> applyUpdateEvent(UpdateEvent updateEvent, WidgetRef ref) async {
  switch(updateEvent.action) {
    case UpdateEvent.uploadNote:
      await appWebChannel.downloadNote(id: updateEvent.value, onSuccess: (note) async {
        await note.save(upload: false);
        ref.read(notesProvider.notifier).applyServerUpdate(note);
      });
      break;
    case UpdateEvent.deleteNote:
      final note = ref.watch(notesProvider).notes[updateEvent.value];
      if(note != null) {
        note.delete(upload: false, ref: ref);
        ref.read(notesProvider.notifier).deleteNotes([updateEvent.value]);
      }
      break;
    case UpdateEvent.uploadTheme:
      await appWebChannel.downloadTheme(id: updateEvent.value, onSuccess: (theme) async {
        await theme.save(upload: false);
        ref.read(themesProvider.notifier).insertTheme(theme);
      });
      break;
    case UpdateEvent.deleteTheme:
      final theme = ref.watch(themesProvider).themes[updateEvent.value];
      if(theme != null) {
        theme.delete(upload: false);
        ref.read(themesProvider.notifier).deleteTheme(theme.id);
      }
      break;
    case UpdateEvent.renameUser:
      appStorage.selectedUser.name = updateEvent.value;
      appStorage.saveSelectedUserInformation(updateEvent: null);
      break;
  }

  appWebChannel.acknowledgeEvent(updateEvent);
}