import 'package:amphi/extensions/color_extension.dart';
import 'package:amphi/models/app.dart';
import 'package:amphi/models/app_localizations.dart';
import 'package:amphi/widgets/color/picker/color_picker_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/components/note_editor/edit_style/edit_note_text_size.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/models/app_colors.dart';
import 'package:notes/providers/editing_note_provider.dart';

class EditNoteDetail extends ConsumerStatefulWidget {
  final QuillController controller;

  const EditNoteDetail({super.key, required this.controller});

  @override
  ConsumerState<EditNoteDetail> createState() => _EditNoteDetailState();
}

class _EditNoteDetailState extends ConsumerState<EditNoteDetail> {
  late final TextEditingController lineHeightController = TextEditingController(
      text: ref.watch(editingNoteProvider).note.lineHeight?.toString() ?? "1.0");

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
      if (lineHeight == 1.0) {
        ref.read(editingNoteProvider.notifier).setLineHeight(null);
      } else {
        ref.read(editingNoteProvider.notifier).setLineHeight(lineHeight);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final note = ref.watch(editingNoteProvider).note;
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
                  Text(AppLocalizations.of(context)
                      .get("@note_background_color")),
                  IconButton(
                      icon: Icon(Icons.circle,
                          color: note.backgroundColorByTheme(context)),
                      onPressed: () {
                        showAdaptiveColorPicker(
                            context: context,
                            color: note.backgroundColorByTheme(context),
                            onAddColor: (color) {
                              appColors.noteBackgroundColors.add(color);
                              appColors.save();
                            },
                            onColorChanged: (value) {
                              var color = value;
                              if (Theme.of(context).brightness ==
                                  Brightness.dark) {
                                color = value.inverted();
                              }
                              ref
                                  .read(editingNoteProvider.notifier)
                                  .setBackgroundColor(color);
                            },
                            colors: appColors.noteTextColors,
                            onRemoveColor: (color) {
                              appColors.noteBackgroundColors.remove(color);
                              appColors.save();
                            },
                            defaultColor: themeData.cardColor,
                            onDefaultColorTap: (value) {
                              ref
                                  .read(editingNoteProvider.notifier)
                                  .setBackgroundColor(null);
                            });
                      })
                ],
              ),
              Row(
                children: [
                  Text(AppLocalizations.of(context).get("@note_text_color")),
                  IconButton(
                      icon: Icon(Icons.circle,
                          color: note.textColorByTheme(context) ??
                              themeData.textTheme.bodyMedium!.color),
                      onPressed: () {
                        showAdaptiveColorPicker(
                            context: context,
                            color: note.textColorByTheme(context) ??
                                themeData.textTheme.bodyMedium!.color!,
                            onAddColor: addNoteTextColor,
                            onColorChanged: (value) {
                              var color = value;
                              if (Theme.of(context).brightness ==
                                  Brightness.dark) {
                                color = value.inverted();
                              }
                              ref
                                  .read(editingNoteProvider.notifier)
                                  .setTextColor(color);
                            },
                            colors: appColors.noteTextColors,
                            onRemoveColor: removeNoteTextColor,
                            defaultColor:
                                Theme.of(context).textTheme.bodyMedium!.color,
                            onDefaultColorTap: (color) {
                              ref
                                  .read(editingNoteProvider.notifier)
                                  .setTextColor(null);
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
                        value: note.textSize ?? 15,
                        controller: widget.controller,
                        onChange: (size) {
                          ref
                              .read(editingNoteProvider.notifier)
                              .setTextSize(size);
                        }),
                  )
                ],
              ),
              Row(
                children: [
                  Text(AppLocalizations.of(context).get("@note_line_height")),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: _EditNoteLineHeight(
                        value: note.lineHeight ?? 1,
                        onChange: (value) {
                          ref
                              .read(editingNoteProvider.notifier)
                              .setLineHeight(value);
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
      FixedExtentScrollController(
          initialItem: _getLineHeightIndex(widget.value, list));
  List<double> list = List.generate(25, (size) => size + 1.toDouble());

  @override
  Widget build(BuildContext context) {
    if (App.isDesktop()) {
      return DropdownButton<double>(
          value: widget.value,
          items: list
              .map((item) => DropdownMenuItem<double>(
                  value: item, child: Text(item.toInt().toString())))
              .toList(),
          onChanged: (item) {
            widget.onChange(item ?? 1);
          });
    } else {
      return SizedBox(
        width: 150,
        height: 200,
        child: CupertinoPicker(
            scrollController: fixedExtentScrollController,
            itemExtent: 30,
            onSelectedItemChanged: (i) async {
              widget.onChange(list[i]);
            },
            children:
                list.map((item) => Text(item.toInt().toString())).toList()),
      );
    }
  }
}

int _getLineHeightIndex(double value, List<double> list) {
  for (int i = 0; i < list.length; i++) {
    if (value == list[i]) {
      return i;
    }
  }
  return 0;
}
