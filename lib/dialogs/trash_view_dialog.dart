
import 'package:flutter/material.dart';
import 'package:amphi/widgets/dialogs/confirmation_dialog.dart';
import 'package:notes/views/notes_view.dart';
import 'package:notes/components/trashes/trash_view_popupmenu_button.dart';
import 'package:amphi/models/app_localizations.dart';

import 'package:notes/models/folder.dart';
import 'package:notes/icons/icons.dart';
import 'package:notes/models/note.dart';

class TrashViewDialog extends StatefulWidget {
  const TrashViewDialog({super.key});

  @override
  State<TrashViewDialog> createState() => _TrashViewDialogState();
}

class _TrashViewDialogState extends State<TrashViewDialog> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      // canPop: appStorage.selectedNotes == null,
      // onPopInvokedWithResult: (value, result) {
      //   if (appStorage.selectedNotes != null) {
      //     setState(() {
      //       appStorage.selectedNotes = null;
      //     });
      //   }
      // },
      child: Dialog(
        // child: Container(
        //   width: 250,
        //   height:  MediaQuery.of(context).size.height >= 500 ? 500 : null,
        //   child: Stack(
        //       children: [
        //         Align(
        //           alignment: Alignment.topRight,
        //           child: IconButton(
        //               icon: Icon(AppIcons.times),
        //               onPressed: () {
        //                 Navigator.pop(context);
        //               }),
        //         ),
        //         Positioned(
        //             left: 0,
        //             right: 0,
        //             top: 50,
        //             bottom: 15,
        //             child: Scaffold(
        //               appBar: AppBar(
        //                 leadingWidth: 160,
        //                 leading: Align(
        //                   alignment: Alignment.topLeft,
        //                     child: Visibility(
        //                       visible: appStorage.selectedNotes  != null,
        //                       child: IconButton(icon: Icon(AppIcons.check), onPressed: () {
        //                         setState(() {
        //                           appStorage.selectedNotes = null;
        //                         });
        //                       }),
        //                     ),
        //
        //                 ),
        //                 actions: appStorage.selectedNotes != null ? <Widget>[
        //                   IconButton(
        //                       icon: const Icon(Icons.restore),
        //                       onPressed: () {
        //                         AppStorage.restoreSelectedNotes();
        //                       }),
        //                   IconButton(
        //                       icon: const Icon(AppIcons.trash),
        //                       onPressed: () {
        //                        showDialog(context: context, builder: (context) {
        //                          return ConfirmationDialog(title: AppLocalizations.of(context).get("@dialog_title_delete_selected_notes"), onConfirmed: () {
        //                            for(dynamic item in appStorage.selectedNotes!) {
        //                              if(item is Note) {
        //                                item.delete();
        //                                AppStorage.trashes().remove(item);
        //                              }
        //                              else if(item is Folder) {
        //                                item.delete();
        //                                AppStorage.trashes().remove(item);
        //                              }
        //                            }
        //                            setState(() {
        //                              appStorage.selectedNotes = null;
        //                            });
        //                          });
        //                        });
        //                       })
        //                 ] :
        //                 <Widget>[
        //                   TrashViewPopupMenuButton()
        //                 ],
        //               ),
        //               body: Stack(
        //                 children: [
        //                   Positioned(
        //                     left: 7.5,
        //                     right: 7.5,
        //                     bottom: 7.5,
        //                     top: 0,
        //                     child: NoteListView(
        //                       noteList: AppStorage.trashes(),
        //                       onLongPress: () {
        //                         setState(() {
        //                           appStorage.selectedNotes = [];
        //                         });
        //                       },
        //                       onNotePressed: (note) {
        //
        //                       },
        //                      toUpdateFolder: (folder) {},
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ))
        //
        //       ]),
        // ),
      ),
    );
  }
}
