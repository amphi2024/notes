import 'package:amphi/models/app_localizations.dart';
import 'package:amphi/widgets/dialogs/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:notes/components/draggable_page.dart';
import 'package:notes/views/notes_view.dart';

import 'package:notes/models/folder.dart';
import 'package:notes/icons/icons.dart';
import 'package:notes/models/note.dart';

import '../models/app_storage.dart';

class TrashPage extends StatefulWidget {
  const TrashPage({super.key});

  @override
  State<TrashPage> createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggablePage(
      child: PopScope(
        // canPop: appStorage.selectedNotes == null,
        // onPopInvokedWithResult: (value, data) {
        //   if (appStorage.selectedNotes != null) {
        //     setState(() {
        //       appStorage.selectedNotes = null;
        //     });
        //   }
        // },
        child: Scaffold(
          appBar: AppBar(
            leadingWidth: 160,
            leading: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // appStorage.selectedNotes == null
                //     ? ElevatedButton(
                //         onPressed: () {
                //           Navigator.pop(context);
                //         },
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             const Icon(
                //               AppIcons.back,
                //               size: 25,
                //             ),
                //             Text(
                //               AppLocalizations.of(context).get("@trash"),
                //               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                //             )
                //           ],
                //         ),
                //       )
                //     : IconButton(
                //         icon: Icon(AppIcons.check),
                //         onPressed: () {
                //           setState(() {
                //             appStorage.selectedNotes = null;
                //           });
                //         }),
              ],
            ),
            // actions: appStorage.selectedNotes != null
            //     ? <Widget>[
            //         IconButton(
            //             icon: const Icon(Icons.restore),
            //             onPressed: () {
            //               // AppStorage.restoreSelectedNotes();
            //             }),
            //         IconButton(
            //             icon: const Icon(AppIcons.trash),
            //             onPressed: () {
            //               showDialog(
            //                   context: context,
            //                   builder: (context) {
            //                     return ConfirmationDialog(
            //                         title: AppLocalizations.of(context).get("@dialog_title_delete_selected_notes"),
            //                         onConfirmed: () {
            //                           // for (dynamic item in appStorage.selectedNotes!) {
            //                           //   if (item is Note) {
            //                           //     item.delete();
            //                           //     AppStorage.trashes().remove(item);
            //                           //   } else if (item is Folder) {
            //                           //     item.delete();
            //                           //     AppStorage.trashes().remove(item);
            //                           //   }
            //                           // }
            //                           // setState(() {
            //                           //   appStorage.selectedNotes = null;
            //                           // });
            //                         });
            //                   });
            //             })
            //       ]
            //     : <Widget>[TrashViewPopupMenuButton()],
          ),
          body: Stack(
            children: [
              // Positioned(
              //   left: 7.5,
              //   right: 7.5,
              //   bottom: 7.5,
              //   top: 0,
              //   child: NoteListView(
              //     noteList: AppStorage.trashes(),
              //     onLongPress: () {
              //       setState(() {
              //         appStorage.selectedNotes = [];
              //       });
              //     },
              //     onNotePressed: (note) {},
              //     toUpdateFolder: (folder) {},
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
