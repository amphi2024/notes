import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

extension EditorExtension on QuillController {
  void removeAttributeWithoutKeyboard(Attribute attribute) {
    skipRequestKeyboard = true;
    if (getSelectionStyle().containsKey(attribute.key)) {
      formatSelection(Attribute.clone(attribute, null));
    }
  }

  int getFontSizeIndex(List<double> fontSizeList) {
    int i = 0;
    for (i; i < fontSizeList.length; i++) {
      if (fontSizeList[i].toString() == (getSelectionStyle().attributes[Attribute.size.key]?.value ?? "15.0")) {
        break;
      }
    }
    return i;
  }

  void insertBlock(BlockEmbed blockEmbed) {
    final index = selection.baseOffset;

    replaceText(index, 0, blockEmbed, const TextSelection.collapsed(offset: 0));
  }

  void formatSelectionWithoutKeyboard(Attribute? attribute) {
    skipRequestKeyboard = true;
    formatSelection(attribute);
  }

  Color? selectionBackgroundColor() {
    final attribute = getSelectionStyle().attributes[Attribute.background.key];
    if (attribute != null) {
      return Color(int.parse(attribute.value.substring(1), radix: 16) + 0xFF000000);
    } else {
      return null;
    }
  }

  Color currentTextColor(BuildContext context) {
    Color textColor = Theme.of(context).textTheme.bodyMedium!.color!;

    final attribute = getSelectionStyle().attributes['color'];
    if (attribute != null) {
      return Color(int.parse(attribute.value.substring(1), radix: 16) + 0xFF000000);
    } else {
      return textColor;
    }
  }
}