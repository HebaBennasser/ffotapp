// ignore_for_file: depend_on_referenced_packages

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'carbon_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE answers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question TEXT,
        answer TEXT
      )
    ''');
  }

  Future<int> insertAnswer(String question, String answer) async {
    final db = await database;
    return await db.insert('answers', {
      'question': question,
      'answer': answer,
    });
  }

  Future<List<Map<String, dynamic>>> getAnswers() async {
    final db = await database;
    return await db.query('answers');
  }

  Future<void> deleteAllAnswers() async {
    final db = await database;
    await db.delete('answers');
  }
}