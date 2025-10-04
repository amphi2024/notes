import 'dart:math';
import 'package:sqflite/sqflite.dart';

Future<String> generatedNoteId(Database db) async {
  const chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  final random = Random();
  while(true) {
    var length = random.nextInt(5) + 15;
    final id = List.generate(length, (_) => chars[random.nextInt(chars.length)]).join();

    final res = await db.rawQuery('SELECT 1 FROM notes WHERE id = ? LIMIT 1;', [id]);
    if (res.isEmpty) {
      return id;
    }
  }
}