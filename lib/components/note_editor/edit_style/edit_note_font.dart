import 'package:amphi/models/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/components/font.dart';
import 'package:flutter_quill/flutter_quill.dart';

class EditNoteFont extends StatefulWidget {
  final QuillController noteEditingController;
  final void Function(String) onChange;
  const EditNoteFont({super.key, required this.noteEditingController, required this.onChange});

  @override
  State<EditNoteFont> createState() => _EditNoteFontState();
}

class _EditNoteFontState extends State<EditNoteFont> {
  late Map<String, String> fonts = getAllFontsByMap(context);
  late List<Font> fontList = getAllFonts(context);

  @override
  Widget build(BuildContext context) {
    if(App.isDesktop()) {
      return DropdownButton<String>(
          style: Theme.of(context).textTheme.bodyMedium,
          value: widget.noteEditingController.getSelectionStyle().attributes[Attribute.font.key]?.value ?? "",
          items: fonts.entries.map((entry) => DropdownMenuItem<String>(value: entry.value, child: Text(entry.key)) ).toList(),
          onChanged: (item) {
            if(item != null) {
              widget.onChange(item);
            }
          });
    }
    else {
      return SizedBox(
        width: 150,
        height: 200,
        child: CupertinoPicker(
            scrollController: FixedExtentScrollController(),
            itemExtent: 30,
            onSelectedItemChanged: (i) {
              widget.onChange(fontList[i].font);
            },
            children: fontList),
      );
    }
  }
}
