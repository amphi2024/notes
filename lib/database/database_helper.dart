import 'dart:io';

import 'package:notes/models/app_storage.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../utils/notes_migration.dart';
import '../utils/theme_migration.dart';

final databaseHelper = DatabaseHelper.instance;

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if(Platform.isWindows || Platform.isLinux) {
      final databaseFactory = databaseFactoryFfi;
      final db = await databaseFactory.openDatabase(appStorage.databasePath, options: OpenDatabaseOptions(
        onCreate: _onCreate,
        version: 1
      ));
      return db;
    }
    return await openDatabase(
      appStorage.databasePath,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute("""
           CREATE TABLE IF NOT EXISTS notes (
            id TEXT PRIMARY KEY NOT NULL, 
            content TEXT, 
            created INTEGER NOT NULL,
            modified INTEGER NOT NULL,
            deleted INTEGER,
            is_folder BOOLEAN,
            parent_id TEXT,
            line_height INTEGER,
            text_size INTEGER,
            text_color INTEGER,
            background_color INTEGER,
            background TEXT,
            title TEXT,
            subtitle TEXT
          );""");

    await db.execute("""
           CREATE TABLE IF NOT EXISTS themes (
            id TEXT PRIMARY KEY NOT NULL,
            title TEXT NOT NULL,
            created INTEGER NOT NULL,
            modified INTEGER NOT NULL,

            background_light INTEGER NOT NULL,
            text_light INTEGER NOT NULL,
            accent_light INTEGER NOT NULL,
            card_light INTEGER NOT NULL,
            floating_button_background_light INTEGER NOT NULL,
            floating_button_icon_light INTEGER NOT NULL,

            background_dark INTEGER NOT NULL,
            text_dark INTEGER NOT NULL,
            accent_dark INTEGER NOT NULL,
            card_dark INTEGER NOT NULL,
            floating_button_background_dark INTEGER NOT NULL,
            floating_button_icon_dark INTEGER NOT NULL
          );""");

    await migrateNotes(db);
    await migrateThemes(db);
  }

  Future<void> close() async {
    await _database?.close();
    _database = null;
  }
}
