
import 'dart:ui';

abstract class Item {
  String title;
  String filename;
  String path;
  String location;

  DateTime created;
  DateTime modified;
  DateTime originalCreated;
  DateTime originalModified;
  DateTime? deleted;

  Color? backgroundColor;
  Color? textColor;
  bool editedModified = false;
  bool editedCreated = false;

  Item({
    required this.filename,
    required this.path,
    required this.location,
    required this.created,
    required this.originalCreated,
    required this.modified,
    required this.originalModified,
    this.deleted,
    this.title = ""
  });

}