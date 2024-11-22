import 'package:flutter/material.dart';

TableCell editableTableImage({required String filename, required bool readOnly}) {
  return TableCell(
      child: GestureDetector(
    onTap: () {},
    // child: ImageFromStorage(filename: filename, noteFilename: noteFilename)
  ));
}
