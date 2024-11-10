import 'package:flutter/cupertino.dart';
import 'package:notes/models/note.dart';

class ParsedNoteContents extends StatefulWidget {

  final Note note;
  const ParsedNoteContents({super.key, required this.note});

  @override
  State<ParsedNoteContents> createState() => _ParsedNoteContentsState();
}

class _ParsedNoteContentsState extends State<ParsedNoteContents> {
  @override
  Widget build(BuildContext context) {
    return const Column(

    );
  }
}
