import 'package:amphi/models/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:notes/models/folder.dart';
import 'package:notes/icons/icons.dart';

const int insertFolder = 0, updateFolder = 1;

class EditFolderDialog extends StatefulWidget {
  final Folder folder;
  final void Function(Folder) onSave;
  const EditFolderDialog({super.key, required this.folder, required this.onSave});

  @override
  State<EditFolderDialog> createState() => _EditFolderDialogState();
}

class _EditFolderDialogState extends State<EditFolderDialog> {
  late Folder folder = widget.folder;
  final TextEditingController folderNameController = TextEditingController();

  @override
  void initState() {
    folderNameController.text = widget.folder.title;
    super.initState();
  }

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
                    onPressed: () {
                      folder.title = folderNameController.text;
                      folder.save();

                      widget.onSave(folder);
                      Navigator.pop(context);
                    }))
          ],
        ),
      ),
    );
  }
}
