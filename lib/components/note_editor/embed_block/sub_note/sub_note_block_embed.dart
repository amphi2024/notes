import 'package:flutter_quill/flutter_quill.dart';

class SubNoteBlockEmbed extends CustomBlockEmbed {
  const SubNoteBlockEmbed(String value) : super(noteType, value);

  static const String noteType = 'note';

}

