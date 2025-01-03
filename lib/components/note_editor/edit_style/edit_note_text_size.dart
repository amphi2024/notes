import 'package:amphi/models/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/components/note_editor/note_editing_controller.dart';

class EditNoteTextSize extends StatefulWidget {
  final NoteEditingController noteEditingController;
  final void Function(double) onChange;
  final double value;
  const EditNoteTextSize({super.key, required this.noteEditingController, required this.onChange, required this.value});

  @override
  State<EditNoteTextSize> createState() => _EditNoteTextSizeState();
}

class _EditNoteTextSizeState extends State<EditNoteTextSize> {

  late FixedExtentScrollController fixedExtentScrollController =
  FixedExtentScrollController(
      initialItem: widget.noteEditingController.getFontSizeIndex(list));
  List<double> list = List.generate(90, (size) => size + 5.toDouble());
  @override
  Widget build(BuildContext context) {
    if(App.isDesktop()) {
      return DropdownButton<double>(
          value: widget.value,
          items: list.map((item) => DropdownMenuItem<double>(value: item,  child: Text( widget.noteEditingController.note.textSize == item ? "Default": item.toInt().toString()))).toList(),
          onChanged: (item) {
            widget.onChange(item ?? 15);
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
