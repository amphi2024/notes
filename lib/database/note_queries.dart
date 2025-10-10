import 'dart:convert';

import 'package:notes/models/note.dart';
import 'package:sqflite/sqflite.dart';

extension NoteQueries on Database {
  Future<void> insertNote(Note note) async {
    await rawInsert("""
    INSERT INTO notes (
                    id, content, created, modified, deleted, is_folder, parent_id,
                    line_height, text_size, text_color, background_color, background,
                    title, subtitle
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                ON CONFLICT(id) DO UPDATE SET
                  content = excluded.content,
                  modified = excluded.modified,
                  deleted = excluded.deleted,
                  is_folder = excluded.is_folder,
                  parent_id = excluded.parent_id,
                  line_height = excluded.line_height,
                  text_size = excluded.text_size,
                  text_color = excluded.text_color,
                  background_color = excluded.background_color,
                  background = excluded.background,
                  title = excluded.title,
                  subtitle = excluded.subtitle;
    """, [
      note.id, note.isFolder? null : jsonEncode(note.content), note.created.toUtc().millisecondsSinceEpoch, note.modified.toUtc().millisecondsSinceEpoch, note.deleted?.toUtc().millisecondsSinceEpoch, note.isFolder ? 1 : 0, note.parentId.isEmpty ? null : note.parentId, note.lineHeight?.toInt(), note.textSize?.toInt(), note.textColor?.value, note.backgroundColor?.value,  null, note.isFolder ? note.title : null, null
    ]);
  }
}