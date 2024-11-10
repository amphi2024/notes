import 'package:flutter/material.dart';
import 'package:notes/models/app_theme_data.dart';
import 'package:notes/models/note.dart';

class WideEditNoteView extends StatefulWidget {

  final Note note;
  final bool readOnly;
  const WideEditNoteView({super.key, required this.note, required this.readOnly});

  @override
  State<WideEditNoteView> createState() => _WideEditNoteViewState();
}

class _WideEditNoteViewState extends State<WideEditNoteView> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).noteThemeData(context),
      child: Scaffold(

      ),
    );
  }
}
