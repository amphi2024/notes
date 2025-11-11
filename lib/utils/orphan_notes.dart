import 'package:notes/models/note.dart';
import 'package:sqflite/sqflite.dart';

Future<void> checkOrphanNotes(Database database) async {
  final List<Map<String, dynamic>> list = await database.rawQuery("SELECT * FROM notes n WHERE parent_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM notes p WHERE p.id = n.parent_id);", []);

  for(var data in list) {
    final note = Note.fromMap(data);
    note.parentId = "";
    note.deleted = null;
    await note.save();
  }
}