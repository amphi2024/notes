
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/icons/icons.dart';

class NoteEditorImportButton extends StatelessWidget {

  final QuillController controller;
  const NoteEditorImportButton({super.key, required this.controller});

  void importFromNote() async {
    // var selectedFiles = await FilePicker.platform.pickFiles(allo);
    // var file = selectedFiles?.files.firstOrNull;
    // if(file == null) {
    //   return;
    // }
    // var map = file()

    // if(selectedFiles != null) {
    //   for(var file in selectedFiles.files) {
    //     String fileContent = await file.xFile.readAsString();
    //     Note note = Note.fromFileContent(fileContent: fileContent, originalModified: DateTime.now(), filePath: file.path ?? "");
    //     var directory = Directory(file.xFile.path.split(".").first);
    //       for(Content content in note.contents) {
    //         if(content.type == "img") {
    //           try {
    //             String value = content.value;
    //             if(value.startsWith("!BASE64")) {
    //               var split = value.split(";");
    //               String imageExtension = split[1];
    //               String base64 = split[2];
    //               var file = await noteEditingController.note.createdImageFileWithBase64(base64, imageExtension);
    //               var image = Content(
    //                   value: PathUtils.basename(file.path),
    //                   type: "img"
    //               );
    //               noteEditingController.note.contents.add(image);
    //             }
    //             else {
    //               var file = await noteEditingController.note.createdImageFile(PathUtils.join(directory.path, value));
    //               var image = Content(
    //                   value: PathUtils.basename(file.path),
    //                   type: "img"
    //               );
    //               noteEditingController.note.contents.add(image);
    //             }
    //           }
    //           catch(e) {
    //             noteEditingController.note.contents.add(Content(
    //               value: "{IMAGE}\n",
    //               type: "text"
    //             ));
    //           }
    //
    //         }
    //         else if(content.type == "video") {
    //           try {
    //           var file = await noteEditingController.note.createdVideoFile(PathUtils.join(directory.path, content.value));
    //           var video = Content(
    //               value: PathUtils.basename(file.path),
    //               type: "video"
    //           );
    //           noteEditingController.note.contents.add(video);
    //           }
    //           catch(e) {
    //             noteEditingController.note.contents.add(Content(
    //                 value: "{VIDEO}\n",
    //                 type: "text"
    //             ));
    //           }
    //         }
    //         else {
    //           noteEditingController.note.contents.add(content);
    //         }
    //       }
    //     }
    //     noteEditingController.document = noteEditingController.note.toDocument();
    //
    // }

  }

  // void importFromHTML() async {
  //   Note note = noteEditingController.note;
  //   String? selectedPath = await FilePicker.platform.saveFile(fileName: "${note.title}.html");
  //
  //
  // }
  //
  // void importFromMarkdown() async {
  //   Note note = noteEditingController.note;
  //   String? selectedPath = await FilePicker.platform.saveFile(fileName: "${note.title}.md");
  //
  // }

  // void importFromWord() async {
  //   Note note = noteEditingController.note;
  //   String? selectedPath = await FilePicker.platform.saveFile(fileName: "${note.title}.html");
  //
  //   if (selectedPath != null) {
  //
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    //var localizations = AppLocalizations.of(context);
    return IconButton(
      icon: Icon(AppIcons.import, size: 20),
      onPressed: () {
        importFromNote();
        // showMenuByRelative(context: context, items: [
        //   PopupMenuItem(child: Text(localizations.get("@note_export_label_note")), onTap: importFromNote),
        //   // PopupMenuItem(child: Text(localizations.get("@note_export_label_html")), onTap: importFromHTML),
        //   // PopupMenuItem(child: Text(localizations.get("@note_export_label_markdown")), onTap: importFromMarkdown),
        //   //PopupMenuItem(child: Text(localizations.get("@note_export_label_word")), onTap: importFromWord),
        //   // PopupMenuItem(child: Text(localizations.get("@note_export_label_pdf")), onTap: exportAsPDF),
        // ]);
      },
    );
  }
}