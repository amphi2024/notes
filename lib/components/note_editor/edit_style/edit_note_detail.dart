import 'package:amphi/models/app_localizations.dart';
import 'package:amphi/widgets/color/picker/color_picker_dialog.dart';
import 'package:flutter/material.dart';
import 'package:notes/components/note_editor/edit_style/edit_note_text_size.dart';
import 'package:notes/components/note_editor/note_editing_controller.dart';
import 'package:notes/models/app_colors.dart';

class EditNoteDetail extends StatefulWidget {
  final NoteEditingController noteEditingController;
  final void Function(void Function()) onChange;
  const EditNoteDetail({super.key, required this.noteEditingController, required this.onChange});

  @override
  State<EditNoteDetail> createState() => _EditNoteDetailState();
}

class _EditNoteDetailState extends State<EditNoteDetail> {

  late TextEditingController lineHeightController = TextEditingController(text: widget.noteEditingController.note.lineHeight?.toString() ?? "1.0");

  @override
  void dispose() {
    lineHeightController.dispose();
    super.dispose();
  }

  void addNoteTextColor(Color color) {
    appColors.noteTextColors.add(color);
    appColors.save();
  }

  void removeNoteTextColor(Color color) {
    appColors.noteTextColors.remove(color);
    appColors.save();
  }

  @override
  void initState() {
    lineHeightController.addListener(() {

      var lineHeight = double.tryParse(lineHeightController.text);
      widget.onChange(() {
        if(lineHeight == 1.0) {
          widget.noteEditingController.note.lineHeight = null;
        }
        else {
          widget.noteEditingController.note.lineHeight = lineHeight;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);

    return Container(
      width: 250,
      height: 250,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Text(AppLocalizations.of(context).get("@note_background_color")),
                IconButton(
                    icon: Icon(Icons.circle, color: widget.noteEditingController.note.backgroundColor ?? themeData.scaffoldBackgroundColor),
                    onPressed: () {
                      showAdaptiveColorPicker(
                          context: context,
                          color: themeData.scaffoldBackgroundColor,
                          onAddColor: (color) {
                            appColors.noteBackgroundColors.add(color);
                            appColors.save();
                          },
                          onColorChanged: (color) {
                            widget.onChange(() {
                              widget.noteEditingController.note.backgroundColor = color;
                            });
                          },
                          colors: appColors.noteTextColors,
                          onRemoveColor: (color) {
                            appColors.noteBackgroundColors.remove(color);
                            appColors.save();
                          },
                          defaultColor: themeData.cardColor,
                          onDefaultColorTap: (color) {
                            widget.onChange(() {
                              widget.noteEditingController.note.backgroundColor = null;
                            });
                          });
                    })
              ],
            ),
            Row(
              children: [
                Text(AppLocalizations.of(context).get("@note_text_color")),
                IconButton(
                    icon: Icon(Icons.circle, color: widget.noteEditingController.note.textColor ?? themeData.textTheme.bodyMedium!.color),
                    onPressed: () {
                      showAdaptiveColorPicker(
                          context: context,
                          color: widget.noteEditingController.currentTextColor(context),
                          onAddColor: addNoteTextColor,
                          onColorChanged: (color) {
                            widget.onChange(() {
                              widget.noteEditingController.note.textColor = color;
                            });
                          },
                          colors: appColors.noteTextColors,
                          onRemoveColor: removeNoteTextColor,
                          defaultColor: Theme.of(context).textTheme.bodyMedium!.color,
                          onDefaultColorTap: (color) {
                            widget.onChange(() {
                              widget.noteEditingController.note.textColor = null;
                            });
                          });
                    })
              ],
            ),
            Row(
              children: [
                Text(AppLocalizations.of(context).get("@note_text_size")),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: EditNoteTextSize(
                      value: widget.noteEditingController.note.textSize ?? 15,
                      noteEditingController: widget.noteEditingController,
                      onChange: (size) {
                        widget.onChange(() {
                          widget.noteEditingController.note.textSize = size;
                        });
                      }),
                )
              ],
            ),
            Row(
              children: [
                Text(AppLocalizations.of(context).get("@note_line_height")),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SizedBox(
                    width: 50,
                    child: TextField(
                      controller: lineHeightController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
