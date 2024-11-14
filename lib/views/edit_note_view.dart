import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/channels/app_method_channel.dart';
import 'package:amphi/widgets/dialogs/confirmation_dialog.dart';
import 'package:notes/components/edit_note/edit_note_toolbar.dart';

import 'package:notes/components/note_editor/embed_block/image/image_block_embed.dart';
import 'package:notes/components/note_editor/embed_block/video/video_block_embed.dart';
import 'package:notes/components/note_editor/note_editing_controller.dart';
import 'package:notes/components/note_editor/note_editor.dart';
import 'package:amphi/models/app_localizations.dart';
import 'package:notes/components/note_editor/toolbar/buttons/note_editor_detail_button.dart';
import 'package:notes/components/note_editor/toolbar/buttons/note_editor_redo_button.dart';
import 'package:notes/components/note_editor/toolbar/buttons/note_editor_undo_button.dart';
import 'package:notes/models/app_settings.dart';
import 'package:notes/models/app_state.dart';
import 'package:notes/models/app_theme_data.dart';
import 'package:notes/models/icons.dart';
import 'package:notes/models/note.dart';
import 'package:notes/models/note_embed_blocks.dart';

class EditNoteView extends StatefulWidget {
  final bool createNote;
  final void Function(Note) onSave;

  const EditNoteView({super.key, required this.createNote, required this.onSave});

  @override
  State<EditNoteView> createState() => _EditNoteViewState();
}

class _EditNoteViewState extends State<EditNoteView> {
  Note? originalNote;

  @override
  void dispose() {
    noteEmbedBlocks.clear();
    super.dispose();
  }

  void onPopInvoked(bool? value, dynamic result) {
    if (!appState.noteEditingController.document.isEmpty() && !appState.noteEditingController.readOnly) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return ConfirmationDialog(
                title: AppLocalizations.of(context).get("@dialog_title_not_save_note"),
                onConfirmed: () {
                  appState.noteEditingController.readOnly = true;
                  if (!widget.createNote) {
                    setState(() {
                      appState.noteEditingController.setNote(originalNote!);
                      appState.noteEditingController.readOnly = true;
                    });
                  } else {
                    Navigator.pop(context);
                  }
                });
          });
    }
    appMethodChannel.setNavigationBarColor(Theme.of(context).scaffoldBackgroundColor, appSettings.transparentNavigationBar);
  }

  @override
  void initState() {
    // appMethodChannel.onImageSelected = (path) {
    //   final block = BlockEmbed.custom(
    //     ImageBlockEmbed(path),
    //   );
    //   //  final block =  BlockEmbed.image(path);
    //   appState.noteEditingController.insertBlock(block);
    // };

    // appMethodChannel.onVideoSelected = (path) {
    //   final block = BlockEmbed.custom(
    //     VideoBlockEmbed(path),
    //   );
    //   appState.noteEditingController.insertBlock(block);
    // };

    if (!widget.createNote) {
      originalNote = appState.noteEditingController.note;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NoteEditingController noteEditingController = appState.noteEditingController;

    appMethodChannel.setNavigationBarColor(Theme.of(context).colorScheme.surface, appSettings.transparentNavigationBar);
    return PopScope(
      canPop: noteEditingController.readOnly || (!File(noteEditingController.note.path).existsSync() && noteEditingController.document.isEmpty()),
      onPopInvokedWithResult: onPopInvoked,
      child: Theme(
          data: Theme.of(context).noteThemeData(context),
          child: Scaffold(
              appBar: AppBar(
                leadingWidth: 50,
                automaticallyImplyLeading: false,
                toolbarHeight: 50,
                titleSpacing: 0.0,
                leading: IconButton(
                    onPressed: () {
                      if (!appState.noteEditingController.document.isEmpty() && !appState.noteEditingController.readOnly) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ConfirmationDialog(
                                  title: AppLocalizations.of(context).get("@dialog_title_not_save_note"),
                                  onConfirmed: () {
                                    if (!widget.createNote && appState.noteEditingController.readOnly == false) {
                                      setState(() {
                                        appState.noteEditingController.setNote(originalNote!);
                                        appState.noteEditingController.readOnly = true;
                                      });
                                    } else {
                                      appState.noteEditingController.readOnly = true;
                                      Navigator.pop(context);
                                    }
                                  });
                            });
                      } else {
                        Navigator.pop(context);
                      }
                      appMethodChannel
                          .setNavigationBarColor(Theme.of(context).scaffoldBackgroundColor, appSettings.transparentNavigationBar);
                    },
                    icon: const Icon(AppIcons.back)),
                actions: [
                  Visibility(
                      visible: appState.noteEditingController.readOnly,
                      child: NoteEditorDetailButton(noteEditingController: appState.noteEditingController)),
                  Visibility(
                      visible: !appState.noteEditingController.readOnly,
                      child: NoteEditorUndoButton(noteEditingController: appState.noteEditingController)),
                  Visibility(
                      visible: !appState.noteEditingController.readOnly,
                      child: NoteEditorRedoButton(noteEditingController: appState.noteEditingController)),
                  IconButton(
                      onPressed: () {
                        if (noteEditingController.readOnly) {
                          setState(() {
                            noteEditingController.readOnly = false;
                          });
                        } else {
                          if (!widget.createNote) {
                            setState(() {
                              appState.noteEditingController.readOnly = true;
                            });
                          } else {
                            appState.noteEditingController.readOnly = true;
                            Navigator.pop(context);
                          }
                          Note note = appState.noteEditingController.getNote();
                          // Note note = Note.createdNote("");
                          widget.onSave(note);
                        }
                      },
                      icon: Icon(
                        noteEditingController.readOnly ? Icons.edit : Icons.check_circle_outline,
                        size: 25,
                      ))
                ],
              ),
              body: Stack(
                children: [
                  Positioned(
                      left: 10,
                      right: 10,
                      bottom: appState.noteEditingController.readOnly ? 0 : 60,
                      top: 0,
                      child: NoteEditor(
                        noteEditingController: appState.noteEditingController,
                      )),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Visibility(
                      visible: !appState.noteEditingController.readOnly,
                      child: EditNoteToolbar(noteEditingController: appState.noteEditingController, onNoteStyleChange: (function) {
                        setState(function);
                      }),
                    ),
                  ),
                ],
              ))),
    );
  }
}
