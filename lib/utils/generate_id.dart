import 'dart:math';
import 'package:notes/database/database_helper.dart';

Future<String> generatedNoteId() async {
  const chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  final random = Random();
  while(true) {
    var length = random.nextInt(5) + 15;
    final id = List.generate(length, (_) => chars[random.nextInt(chars.length)]).join();

    final res = await (await databaseHelper.database).rawQuery('SELECT 1 FROM notes WHERE id = ? LIMIT 1;', [id]);
    if (res.isEmpty) {
      return id;
    }
  }
}

Future<String> generatedThemeId() async {
  const chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  final random = Random();
  while(true) {
    var length = random.nextInt(5) + 15;
    final id = List.generate(length, (_) => chars[random.nextInt(chars.length)]).join();

    final res = await (await databaseHelper.database).rawQuery('SELECT 1 FROM themes WHERE id = ? LIMIT 1;', [id]);
    if (res.isEmpty) {
      return id;
    }
  }
}