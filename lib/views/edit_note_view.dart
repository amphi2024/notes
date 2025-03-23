import 'dart:io';

import 'package:amphi/models/app_localizations.dart';
import 'package:amphi/widgets/dialogs/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:notes/channels/app_method_channel.dart';
import 'package:notes/components/edit_note/edit_note_toolbar.dart';
import 'package:notes/components/note_editor/note_editing_controller.dart';
import 'package:notes/components/note_editor/note_editor.dart';
import 'package:notes/components/note_editor/toolbar/note_editor_detail_button.dart';
import 'package:notes/components/note_editor/toolbar/note_editor_export_button.dart';
import 'package:notes/components/note_editor/toolbar/note_editor_import_button.dart';
import 'package:notes/components/note_editor/toolbar/note_editor_redo_button.dart';
import 'package:notes/components/note_editor/toolbar/note_editor_undo_button.dart';
import 'package:notes/main.dart';
import 'package:notes/models/app_state.dart';
import 'package:notes/models/app_theme_data.dart';
import 'package:notes/models/icons.dart';
import 'package:notes/models/item.dart';
import 'package:notes/models/note.dart';
import 'package:notes/models/note_embed_blocks.dart';

import '../dialogs/draft_dialog.dart';

class EditNoteView extends StatefulWidget {
  final NoteEditingController noteEditingController;
  final bool createNote;
  final void Function(Note) onSave;

  const EditNoteView({super.key, required this.createNote, required this.onSave, required this.noteEditingController});

  @override
  State<EditNoteView> createState() => _EditNoteViewState();
}

class _EditNoteViewState extends State<EditNoteView> {
  Note? originalNote;

  @override
  void dispose() {
    noteEmbedBlocks.clear();
    appState.draftSaveTimer?.cancel();
    super.dispose();
  }

  void onPopInvoked(bool? value, dynamic result) {
    if (!widget.noteEditingController.document.isEmpty() && !widget.noteEditingController.readOnly) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return ConfirmationDialog(
                title: AppLocalizations.of(context).get("@dialog_title_not_save_note"),
                onConfirmed: () {
                  widget.noteEditingController.readOnly = true;
                  if (!widget.createNote) {
                    setState(() {
                      widget.noteEditingController.setNote(originalNote!);
                      widget.noteEditingController.readOnly = true;
                    });
                  } else {
                    Navigator.pop(context);
                  }
                });
          });
    }
    appMethodChannel.setNavigationBarColor(Theme.of(context).scaffoldBackgroundColor);
  }

  @override
  void initState() {
    if (!widget.createNote) {
      originalNote = widget.noteEditingController.note;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NoteEditingController noteEditingController = widget.noteEditingController;
    var themeData = Theme.of(context);
    appMethodChannel.setNavigationBarColor(noteEditingController.note.backgroundColorByTheme(themeData.isDarkMode()) ?? Theme.of(context).colorScheme.surface);
    return PopScope(
      canPop: noteEditingController.readOnly || (!File(noteEditingController.note.path).existsSync() && noteEditingController.document.isEmpty()),
      onPopInvokedWithResult: onPopInvoked,
      child: Theme(
          data: Theme.of(context).noteThemeData(),
          child: Scaffold(
            backgroundColor: noteEditingController.note.backgroundColorByTheme(themeData.isDarkMode()),
              appBar: AppBar(
                backgroundColor: noteEditingController.note.backgroundColorByTheme(themeData.isDarkMode()),
                leading: IconButton(
                    onPressed: () {
                      if (!widget.noteEditingController.document.isEmpty() && !widget.noteEditingController.readOnly) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ConfirmationDialog(
                                  title: AppLocalizations.of(context).get("@dialog_title_not_save_note"),
                                  onConfirmed: () {
                                    appState.deleteDraft(widget.noteEditingController.note);
                                    if (!widget.createNote && widget.noteEditingController.readOnly == false) {
                                      setState(() {
                                        widget.noteEditingController.setNote(originalNote!);
                                        widget.noteEditingController.readOnly = true;
                                      });
                                    } else {
                                      widget.noteEditingController.readOnly = true;
                                      Navigator.pop(context);
                                    }
                                  });
                            });
                      } else {
                        Navigator.pop(context);
                      }
                      appMethodChannel.setNavigationBarColor(Theme.of(context).scaffoldBackgroundColor);
                    },
                    icon: const Icon(AppIcons.back)),
                actions: [
                  Visibility(
                      visible: widget.noteEditingController.readOnly,
                      child: NoteEditorExportButton(noteEditingController: widget.noteEditingController)),
                  Visibility(
                      visible: widget.noteEditingController.readOnly,
                      child: NoteEditorDetailButton(noteEditingController: widget.noteEditingController)),
                  Visibility(
                      visible: !widget.noteEditingController.readOnly,
                      child: NoteEditorImportButton(noteEditingController: widget.noteEditingController)),
                  Visibility(
                      visible: !widget.noteEditingController.readOnly,
                      child: NoteEditorUndoButton(noteEditingController: widget.noteEditingController)),
                  Visibility(
                      visible: !widget.noteEditingController.readOnly,
                      child: NoteEditorRedoButton(noteEditingController: widget.noteEditingController)),
                  IconButton(
                      onPressed: () {
                        if (noteEditingController.readOnly) {
                          appState.noteEditingController.note.getDraft((draftNote) {
                            appState.startDraftSave();
                            if(draftNote != null) {
                              showDialog(context: context, builder: (context) {
                                return DraftDialog(
                                  onCanceled: () {
                                    setState(() {
                                      noteEditingController.readOnly = false;
                                    });
                                  },
                                  onConfirmed: () {
                                    noteEditingController.note.contents = draftNote.contents;
                                    noteEditingController.setNote(noteEditingController.note);
                                    setState(() {
                                      noteEditingController.readOnly = false;
                                    });
                                  },
                                );
                              });
                            }
                            else {
                              setState(() {
                                noteEditingController.readOnly = false;
                              });
                            }
                          });
                        } else {
                          if (!widget.createNote) {
                            setState(() {
                              widget.noteEditingController.readOnly = true;
                            });
                          } else {
                            widget.noteEditingController.readOnly = true;
                            Navigator.pop(context);
                          }
                          Note note = widget.noteEditingController.getNote();
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
                      bottom: widget.noteEditingController.readOnly ? 0 : 60,
                      top: 0,
                      child: NoteEditor(
                        noteEditingController: widget.noteEditingController,
                      )),
                  Positioned(
                    bottom: bottomPaddingIfAndroid3Button(context) + 10,
                    left: 0,
                    right: 0,
                    child: Visibility(
                      visible: !widget.noteEditingController.readOnly,
                      child: EditNoteToolbar(
                          noteEditingController: widget.noteEditingController,
                          onNoteStyleChange: (function) {
                            setState(function);
                          }),
                    ),
                  ),
                ],
              ))),
    );
  }
}
