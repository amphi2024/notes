import 'dart:convert';
import 'dart:io';

import 'package:amphi/models/app.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:notes/extensions/date_extension.dart';
import 'package:amphi/models/app_localizations.dart';
import 'package:notes/extensions/note_extension.dart';
import 'package:notes/models/app_storage.dart';
import 'package:notes/models/content.dart';
import 'package:notes/models/note.dart';

class NoteDetailDialog extends StatelessWidget {

  final Note note;
  const NoteDetailDialog({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    int length = 0;
    for(Content content in note.contents) {
      if(content.type == "text") {
        String value = content.value;
        length += value.length;
      }
    }
    return Dialog(
      child: Container(
        width: 300,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10)
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText("${AppLocalizations.of(context).get("@created_date")}: ${note.created.toLocalizedString(context)} \n${AppLocalizations.of(context).get("@modified_date")}: ${note.modified.toLocalizedString(context)}\n${AppLocalizations.of(context).get("@length")}: $length"),
                // TextButton( child: Text(AppLocalizations.of(context).get( "@editor_export_note_as_html")), onPressed: () {
                //
                // }),
                // _ExportButton(
                //     title: "@editor_export_note_as_html",
                //     onPressed: () {
                //
                // }),
                Text("Export"),
                Divider(),
                IconButton(onPressed: () async {
                  String? selectedPath = await FilePicker.platform.saveFile(
                      fileName: "${note.title}.html"
                  );

                  if (selectedPath != null) {
                    if (App.isDesktop()) {
                      print(selectedPath.split(".").first);
                      print(selectedPath);
                      Directory directory = Directory(selectedPath.split(".").first);
                      String html = note.toHTML(directory.path.split("/").last.split(".").first);
                      File file = File(selectedPath);
                      await file.writeAsString(html);

                      await directory.create();
                      for(Content content in note.contents) {
                        switch(content.type) {
                          case "img":
                            File file = File("${appStorage.notesPath}/${note.filename.split(".").first}/images/${content.value}");
                           String path = "${directory.path}/${content.value}";
                            file.copy(path);
                            break;

                          case "video":
                            File file = File("${appStorage.notesPath}/${note.filename.split(".").first}/videos/${content.value}");
                            String path = "${directory.path}/${content.value}";
                            file.copy(path);
                            break;
                        }
                      }


                    }
                  }
                }, icon: Icon(Icons.html)),

               // IconButton(onPressed: () {}, icon: Icon(Icons.word))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExportButton extends StatelessWidget {

  final String title;
  final void Function() onPressed;

  const _ExportButton({required this.title, required this.onPressed, });

  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).dividerColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5)
        )
      ),
        child: Text(
          AppLocalizations.of(context).get(title),
            style: TextStyle(
                color: Theme.of(context).cardColor,
              fontWeight: FontWeight.normal
            ),
           ),
    onPressed: onPressed);
  }
}

