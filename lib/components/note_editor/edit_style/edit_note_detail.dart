import 'package:amphi/extensions/color_extension.dart';
import 'package:amphi/models/app.dart';
import 'package:amphi/models/app_localizations.dart';
import 'package:amphi/widgets/color/picker/color_picker_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/components/note_editor/edit_style/edit_note_text_size.dart';
import 'package:notes/components/note_editor/note_editing_controller.dart';
import 'package:notes/models/app_colors.dart';
import 'package:notes/models/item.dart';

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
    var darkMode = themeData.isDarkMode();
    return Container(
      width: 250,
      height: App.isDesktop() ? 200 : 400,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Text(AppLocalizations.of(context).get("@note_background_color")),
                  IconButton(
                      icon: Icon(Icons.circle, color: widget.noteEditingController.note.backgroundColorByTheme(darkMode) ?? themeData.scaffoldBackgroundColor),
                      onPressed: () {
                        showAdaptiveColorPicker(
                            context: context,
                            color: widget.noteEditingController.note.backgroundColorByTheme(darkMode) ?? themeData.scaffoldBackgroundColor,
                            onAddColor: (color) {
                              appColors.noteBackgroundColors.add(color);
                              appColors.save();
                            },
                            onColorChanged: (value) {
                              var color = value;
                              if(Theme.of(context).brightness == Brightness.dark) {
                                color = value.inverted();
                              }
                              setState(() {
                                widget.onChange(() {
                                  widget.noteEditingController.note.backgroundColor = color;
                                });
                              });
                            },
                            colors: appColors.noteTextColors,
                            onRemoveColor: (color) {
                              appColors.noteBackgroundColors.remove(color);
                              appColors.save();
                            },
                            defaultColor: themeData.cardColor,
                            onDefaultColorTap: (value) {
                              setState(() {
                                widget.onChange(() {
                                  widget.noteEditingController.note.backgroundColor = null;
                                });
                              });
                            });
                      })
                ],
              ),
              Row(
                children: [
                  Text(AppLocalizations.of(context).get("@note_text_color")),
                  IconButton(
                      icon: Icon(Icons.circle, color: widget.noteEditingController.note.textColorByTheme(darkMode) ?? themeData.textTheme.bodyMedium!.color),
                      onPressed: () {
                        showAdaptiveColorPicker(
                            context: context,
                            color: widget.noteEditingController.note.textColorByTheme(darkMode) ?? themeData.textTheme.bodyMedium!.color!,
                            onAddColor: addNoteTextColor,
                            onColorChanged: (value) {
                              var color = value;
                              if(Theme.of(context).brightness == Brightness.dark) {
                                color = value.inverted();
                              }
                              setState(() {
                                widget.onChange(() {
                                  widget.noteEditingController.note.textColor = color;
                                });
                              });
                            },
                            colors: appColors.noteTextColors,
                            onRemoveColor: removeNoteTextColor,
                            defaultColor: Theme.of(context).textTheme.bodyMedium!.color,
                            onDefaultColorTap: (color) {
                              setState(() {
                                widget.onChange(() {
                                  widget.noteEditingController.note.textColor = null;
                                });
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
                          setState(() {
                            widget.onChange(() {
                              widget.noteEditingController.note.textSize = size;
                            });
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
                    child: _EditNoteLineHeight(value: widget.noteEditingController.note.lineHeight ?? 1, onChange: (value) {
                      setState(() {
                        widget.onChange(() {
                          widget.noteEditingController.note.lineHeight = value;
                        });
                      });

                    }),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditNoteLineHeight extends StatefulWidget {

  final double value;
  final void Function(double) onChange;
  const _EditNoteLineHeight({required this.value, required this.onChange});

  @override
  State<_EditNoteLineHeight> createState() => _EditNoteLineHeightState();
}

class _EditNoteLineHeightState extends State<_EditNoteLineHeight> {

  late FixedExtentScrollController fixedExtentScrollController =
  FixedExtentScrollController(initialItem: _getLineHeightIndex(widget.value, list));
  List<double> list = List.generate(25, (size) => size + 1.toDouble());
  @override
  Widget build(BuildContext context) {
    if(App.isDesktop()) {
      return DropdownButton<double>(
          value: widget.value,
          items: list.map((item) => DropdownMenuItem<double>(value: item,  child: Text(item.toInt().toString()))).toList(),
          onChanged: (item) {
            widget.onChange(item ?? 1);
          });
    }
    else {
      return SizedBox(
        width: 150,
        height: 200,
        child: CupertinoPicker(
            scrollController: fixedExtentScrollController,
            itemExtent: 30,
            onSelectedItemChanged: (i) async {
              widget.onChange(list[i]);
            },
            children: list.map((item) => Text(item.toInt().toString())).toList() ),
      );
    }
  }
}

int _getLineHeightIndex(double value , List<double> list) {
  for(int i = 0; i < list.length ; i++) {
    if(value == list[i]) {
      return i;
    }
  }
  return 0;
}