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

  void addNoteTextColor(Color color) {
    appColors.noteTextColors.add(color);
    appColors.save();
  }

  void removeNoteTextColor(Color color) {
    appColors.noteTextColors.remove(color);
    appColors.save();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 250,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Text(AppLocalizations.of(context).get("@note_text_color")),
                IconButton(icon: Icon(Icons.circle), onPressed: () {
                  showAdaptiveColorPicker(
                      context: context,
                      color: widget.noteEditingController
                          .currentTextColor(context),
                      onAddColor: addNoteTextColor,
                      onColorChanged: (color) {

                      },
                      colors: appColors.noteTextColors,
                      onRemoveColor: removeNoteTextColor,
                      defaultColor:
                      Theme.of(context).textTheme.bodyMedium!.color,
                      onDefaultColorTap: (color) {

                      });
                })
              ],
            ),
            Row(
              children: [
                Text(AppLocalizations.of(context).get("@note_text_size")),
                EditNoteTextSize(
                    value: widget.noteEditingController.note.textSize ?? 15,
                    noteEditingController: widget.noteEditingController, onChange: (size) {
                  setState(() {
                   // widget.noteEditingController.note.textSize = double.parse(size);
                  });
                  widget.onChange(() {
                    widget.noteEditingController.note.textSize = size;
                  });
                })
              ],
            ),
            Row(
              children: [
                Text(AppLocalizations.of(context).get("@note_background_color")),

              ],
            ),
            Row(
              children: [
                Text(AppLocalizations.of(context).get("@note_line_height")),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
