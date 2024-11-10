import 'package:flutter/material.dart';
import 'package:notes/extensions/date_extension.dart';
import 'package:amphi/models/app_localizations.dart';
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
                TextButton( child: Text(AppLocalizations.of(context).get( "@editor_export_note_as_html")), onPressed: () {

                }),
                _ExportButton(
                    title: "@editor_export_note_as_html",
                    onPressed: () {

                })
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

