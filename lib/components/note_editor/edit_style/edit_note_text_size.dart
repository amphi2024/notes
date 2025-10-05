import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/components/note_editor/editor_extension.dart';

class EditNoteTextSize extends StatefulWidget {

  final QuillController controller;
  final void Function(double) onChange;
  final double value;
  const EditNoteTextSize({super.key, required this.controller, required this.onChange, required this.value});

  @override
  State<EditNoteTextSize> createState() => _EditNoteTextSizeState();
}

class _EditNoteTextSizeState extends State<EditNoteTextSize> {

  late final FixedExtentScrollController fixedExtentScrollController =
  FixedExtentScrollController(
      initialItem: widget.controller.getFontSizeIndex(list));


  @override
  void dispose() {
    fixedExtentScrollController.dispose();
    super.dispose();
  }

  final List<double> list = List.generate(90, (size) => size + 5.toDouble());
  @override
  Widget build(BuildContext context) {
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
