
import 'package:flutter/material.dart';
import 'package:amphi/widgets/dialogs/confirmation_dialog.dart';
import 'package:notes/components/main/list_view/note_list_view.dart';
import 'package:notes/components/trashes/trash_view_popupmenu_button.dart';
import 'package:amphi/models/app_localizations.dart';
import 'package:notes/models/app_storage.dart';
import 'package:notes/models/folder.dart';
import 'package:notes/models/icons.dart';
import 'package:notes/models/note.dart';
import 'package:notes/views/app_view.dart';

class TrashView extends StatefulWidget {

  const TrashView({super.key});

  @override
  State<TrashView> createState() => _TrashViewState();
}

class _TrashViewState extends State<TrashView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return AppView(
      child: PopScope(
        canPop: appStorage.selectedNotes == null,
        onPopInvokedWithResult: (value, data) {
          if (appStorage.selectedNotes != null) {
            setState(() {
              appStorage.selectedNotes = null;
            });
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leadingWidth: 160,
            leading: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                appStorage.selectedNotes == null ? ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        AppIcons.back,
                        size: 25,
                      ),
                      Text(
                        AppLocalizations.of(context).get("@trashes"),
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                      )
                    ],
                  ),
                ) :
                IconButton(icon: Icon(AppIcons.check), onPressed: () {
                  setState(() {
                    appStorage.selectedNotes = null;
                  });
                }),
              ],
            ),
            actions: appStorage.selectedNotes != null ? <Widget>[
              IconButton(
                  icon: const Icon(Icons.restore),
                  onPressed: () {
                    AppStorage.restoreSelectedNotes();
                  }),
              IconButton(
                  icon: const Icon(AppIcons.trash),
                  onPressed: () {
                    showDialog(context: context, builder: (context) {
                    return ConfirmationDialog(title: AppLocalizations.of(context).get("@dialog_title_delete_selected_notes"), onConfirmed: () {
                      for(dynamic item in appStorage.selectedNotes!) {
                        if(item is Note) {
                          item.delete();
                          AppStorage.trashes().remove(item);
                        }
                        else if(item is Folder) {
                          item.delete();
                          AppStorage.trashes().remove(item);
                        }
                      }
                      setState(() {
                        appStorage.selectedNotes = null;
                      });
                    });
                  });
                  })
            ] :
            <Widget>[
              TrashViewPopupMenuButton()
            ],
          ),
          body: Stack(
            children: [
              Positioned(
                left: 7.5,
                right: 7.5,
                bottom: 7.5,
                top: 0,
                child: NoteListView(
                  noteList: AppStorage.trashes(),
                  onLongPress: () {
                    setState(() {
                      AppStorage.getInstance().selectedNotes = [];
                    });
                  },
                  onNotePressed: (note) {

                  },
                  toUpdateFolder: (folder) {},
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }


}
