import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/components/note_editor/editor_extension.dart';
import 'package:notes/providers/editing_note_provider.dart';
import 'package:notes/utils/screen_size.dart';

class EditNoteTextSize extends StatelessWidget {

  final QuillController controller;
  final void Function(double) onChange;
  final double value;
  const EditNoteTextSize({super.key, required this.controller, required this.onChange, required this.value});

  @override
  Widget build(BuildContext context) {
    if (isDesktopOrTablet(context)) {
      return _Wide(
        controller: controller,
        onChange: onChange,
        value: value,
      );
    }
    return _Mobile(
      controller: controller,
      onChange: onChange,
      value: value,
    );
  }
}

class _Wide extends ConsumerStatefulWidget {

  final QuillController controller;
  final void Function(double) onChange;
  final double value;

  const _Wide({required this.controller, required this.onChange, required this.value});

  @override
  ConsumerState<_Wide> createState() => _WideState();
}

class _WideState extends ConsumerState<_Wide> {

  final List<double> list = List.generate(90, (size) => size + 5.toDouble());

  @override
  Widget build(BuildContext context) {

    final defaultSize = ref.watch(editingNoteProvider).note.textSize ?? 15;

    return DropdownButton<double>(
        style: Theme
            .of(context)
            .textTheme
            .bodyMedium,
        value: widget.value,
        items: list.map((item) => DropdownMenuItem<double>(value: item, child: Text(defaultSize == item ? "Default": item.toInt().toString()))).toList(),
    onChanged: (item) {
    widget.onChange(item ?? 15);
    });
  }
}


class _Mobile extends StatefulWidget {

  final QuillController controller;
  final void Function(double) onChange;
  final double value;

  const _Mobile({required this.controller, required this.onChange, required this.value});

  @override
  State<_Mobile> createState() => _MobileState();
}

class _MobileState extends State<_Mobile> {

  late final FixedExtentScrollController fixedExtentScrollController =
  FixedExtentScrollController(
      initialItem: widget.controller.getFontSizeIndex(list));
  final List<double> list = List.generate(90, (size) => size + 5.toDouble());


  @override
  void dispose() {
    fixedExtentScrollController.dispose();
    super.dispose();
  }

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
          children: list.map((item) => Text(item.toInt().toString())).toList()),
    );
  }
}
