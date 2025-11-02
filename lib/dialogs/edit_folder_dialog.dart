import 'package:amphi/models/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/providers/notes_provider.dart';
import 'package:notes/utils/generate_id.dart';
import '../icons/icons.dart';
import '../models/note.dart';

class EditFolderDialog extends StatefulWidget {
  final Note folder;
  final WidgetRef ref;
  const EditFolderDialog({super.key, required this.folder, required this.ref});

  @override
  State<EditFolderDialog> createState() => _EditFolderDialogState();
}

class _EditFolderDialogState extends State<EditFolderDialog> {
  late final TextEditingController folderNameController = TextEditingController(text: widget.folder.title);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        width: 250,
        height: 110,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: Stack(
          children: [
            Positioned(
                left: 10,
                right: 10,
                top: 5,
                child: TextField(
                  controller: folderNameController,
                  decoration: InputDecoration(hintText: AppLocalizations.of(context).get("@hint_folder_name")),
                )),
            Positioned(
                left: 5,
                bottom: 5,
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      AppIcons.times,
                      size: 15,
                    ))),
            Positioned(
                right: 5,
                bottom: 5,
                child: IconButton(
                    icon: const Icon(
                      AppIcons.check,
                      size: 20,
                    ),
                    onPressed: () async {
                      if(widget.folder.id.isEmpty) {
                        widget.folder.id = await generatedNoteId();
                      }
                      widget.folder.title = folderNameController.text;
                      widget.folder.modified = DateTime.now();
                      widget.folder.isFolder = true;
                      widget.folder.save();
                      widget.ref.read(notesProvider.notifier).insertNote(widget.folder);
                      Navigator.pop(context);
                    }))
          ],
        ),
      ),
    );
  }
}
