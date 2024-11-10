import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class NoteEditorCheckboxBuilder extends QuillCheckboxBuilder {

  @override
  Widget build({required BuildContext context, required bool isChecked, required ValueChanged<bool> onChanged}) {
    return Theme(
      data: Theme.of(context),
      child: Checkbox(
          value: isChecked,
          onChanged: (value) {
            onChanged(value!);
          }),
    );
    // return Material(child: NoteEditorCheckbox(appTheme: appTheme));
  }

}