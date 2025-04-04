import 'dart:convert';
import 'dart:io';

import 'package:amphi/utils/path_utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:notes/components/note_editor/embed_block/table/table/table_data.dart';
import 'package:notes/components/note_editor/embed_block/view_pager/view_pager_data.dart';
import 'package:notes/models/content.dart';
import 'package:notes/models/note.dart';
import 'package:notes/models/note_embed_blocks.dart';

class NoteEditingController extends QuillController {
  Future<List<File>> selectedImageFiles() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowMultiple: true, allowedExtensions: [ "webp", "jpg", "jpeg", "png", "gif", "bmp", "tiff", "tif", "svg",
      "ico", "heic", "heif", "jfif", "pjpeg", "pjp", "avif",
      "raw", "dng", "cr2", "nef", "arw", "rw2", "orf", "sr2", "raf", "pef"]);
    List<File> list = [];
    if (result?.files.isNotEmpty ?? false) {
      for(var file in result!.files) {
        list.add(await note.createdImageFile(file.path!));
      }
    }

    return list;

  }

  Future<File?> selectedVideoFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: [
      "mp4", "mov", "avi", "wmv", "mkv", "flv", "webm", "mpeg", "mpg", "m4v", "3gp", "3g2", "f4v", "swf", "vob", "ts"
    ],
    allowMultiple: false
    );

    if (result?.files.isNotEmpty ?? false) {
      final selectedFile = result!.files.first;

      if (selectedFile.path != null) {
        return note.createdVideoFile(selectedFile.path!);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Note note;

  Note getNote() {
    note.contents = [];
    for (Operation operation in document.toDelta().toList()) {
      if (operation.value is String) {
        note.contents.add(Content(value: operation.value, type: "text", style: operation.attributes));
      } else {
        Map<String, dynamic> blockData = jsonDecode(operation.value["custom"]);
        if (blockData.containsKey("image")) {
          String path = blockData["image"];
          note.contents.add(Content(value: PathUtils.basename(path), type: "img"));
        } else if (blockData.containsKey("video")) {
          String path = blockData["video"];
          note.contents.add(Content(value: PathUtils.basename(path), type: "video"));
        } else if (blockData.containsKey("table")) {
          String key = blockData["table"];
          TableData tableData = noteEmbedBlocks.getTable(key);

          note.contents.add(Content(value: tableData.data, type: "table", style: {
            "pages": tableData.pages,
          }));
        } else if (blockData.containsKey("note")) {
          String key = blockData["note"];
          note.contents.add(Content(
              value: {"title": noteEmbedBlocks.getSubNote(key).note.title, "contents": noteEmbedBlocks.getSubNote(key).getNote().contentsToMap()},
              type: "note"));
        } else if (blockData.containsKey("divider")) {
          String key = blockData["divider"];
          Color? color = noteEmbedBlocks.dividers[key];
          if (color != null) {
            note.contents.add(Content(type: "divider", style: {"color": color.value}));
          } else {
            note.contents.add(Content(type: "divider", value: null, style: null));
          }
        } else if (blockData.containsKey("view-pager")) {
          String key = blockData["view-pager"];
          ViewPagerData viewPagerData = noteEmbedBlocks.getViewPager(key);
          note.contents.add(viewPagerData.toContent());
        }
        else if(blockData.containsKey("file")) {
          String key = blockData["file"];
          var fileModel = noteEmbedBlocks.getFile(key);
          note.contents.add(fileModel.toContent());
        }
      }
    }

    return note;
  }

  NoteEditingController({Document? document, TextSelection? selection, required this.note, super.readOnly})
      : super(document: document ?? note.toDocument(), selection: selection ?? const TextSelection(baseOffset: 0, extentOffset: 0));

  void setNote(Note note) {
    this.note = note;
    document = note.toDocument();
  }

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
    // final length = selection.extentOffset - index;

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
