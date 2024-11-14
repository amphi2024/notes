import 'package:flutter_quill/flutter_quill.dart';

class NoteTableBlockEmbed extends CustomBlockEmbed {
  const NoteTableBlockEmbed(String value) : super(noteType, value);

  static const String noteType = 'table';
}