import 'package:amphi/models/update_event.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/channels/app_web_channel.dart';
import 'package:notes/providers/notes_provider.dart';

void refreshDataWithServer(WidgetRef ref) {
  appWebChannel.getNotes(onSuccess: (list) async {
    for (var item in list) {
      final id = item["id"];
      if (id is String) {
        if (!ref.read(notesProvider).notes.containsKey(item["id"])) {
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
        note.initTitles();

        final originalNote = ref.watch(notesProvider).notes.get(updateEvent.value);
        if(originalNote.deleted == null && note.deleted != null) {
          ref.read(notesProvider.notifier).moveNotes([note.id], note.parentId, "!TRASH");
        }
        else if(originalNote.deleted != null && note.deleted == null) {
          ref.read(notesProvider.notifier).moveNotes([note.id], "!TRASH", note.parentId);
        }
        else {
          ref.read(notesProvider.notifier).insertNote(note);
        }
      });
      break;
    case UpdateEvent.deleteNote:

      break;
    case UpdateEvent.uploadTheme:
      break;
    case UpdateEvent.deleteTheme:
      break;
    case UpdateEvent.renameUser:
      break;
  }

  appWebChannel.acknowledgeEvent(updateEvent);
}