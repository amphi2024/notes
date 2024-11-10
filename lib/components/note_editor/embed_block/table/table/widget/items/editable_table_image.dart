import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notes/components/image_from_storage.dart';
import 'package:notes/models/app_storage.dart';

TableCell editableTableImage({required String filename, required bool readOnly}) {
  return  TableCell(
      child: GestureDetector(
          onTap: () {

          },
         // child: ImageFromStorage(filename: filename, noteFilename: noteFilename)
      )
  );
}