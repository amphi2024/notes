import 'package:amphi/models/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:notes/extensions/date_extension.dart';
import 'package:notes/models/content.dart';
import 'package:notes/models/note.dart';

class NoteDetailDialog extends StatelessWidget {
  final Note note;
  const NoteDetailDialog({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    //print(note.filename);
    int length = 0;
    // for (Content content in note.content) {
    //   if (content.type == "text") {
    //     String value = content.value;
    //     length += value.length;
    //   }
    // }
    return Dialog(
      child: Container(
        width: 400,
        height: 150,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                    "${AppLocalizations.of(context).get("@created_date")}: ${note.created.toLocalizedString(context)} \n${AppLocalizations.of(context).get("@modified_date")}: ${note.modified.toLocalizedString(context)}\n${AppLocalizations.of(context).get("@length")}: $length"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
