import 'package:flutter_quill/flutter_quill.dart';

class NoteDataBlockEmbed extends CustomBlockEmbed {
  const NoteDataBlockEmbed(String value) : super(noteType, value);

  static const String noteType = 'data';
}