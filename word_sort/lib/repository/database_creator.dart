import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Database db;

class DatabaseCreator {
  static const wordTable = 'word';
  static const id = 'id';
  static const word = 'word';
  static const description = 'description';
  static const level = 'level';
  static const isDeleted = 'isDeleted';

  static void databaseLog(String functionName, String sql,
      [List<Map<String, dynamic>> selectQueryResult, int insertAndUpdateQueryResult]){
    print(functionName);
    print(sql);
    if(selectQueryResult != null){
      print(selectQueryResult);
    } else if (insertAndUpdateQueryResult != null){
      print(insertAndUpdateQueryResult);
    }
  }

  Future<void> createWordTable(Database db) async {
    final wordSql = '''CREATE TABLE $wordTable(
    $id INTEGER PRIMARY KEY,
    $word TEXT,
    $description TEXT,
    $level INTEGER,
    $isDeleted BIT NOT NULL
    )''';

    await db.execute(wordSql);
  }

  Future<String> getDatabasePath(String dbName) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, dbName);

    if(await Directory(dirname(path)).exists()){
      // await deleteDatabase(path);
    }else{
      await Directory(dirname(path)).create(recursive: true);
    }
  }

  Future<void> initDatabase() async {
    final path = await getDatabasePath('word_db');
    db = await openDatabase(path, version: 1, onCreate: onCreate);
    print(db);
  }

  Future<void> onCreate(Database db, int version) async {
    await createWordTable(db);
  }
}