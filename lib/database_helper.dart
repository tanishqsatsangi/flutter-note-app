import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'note.dart';

class DatabaseHelper {
  static final _dbName = "notestest.db";
  static final _dbVersion = 1;
  static final _tableName = "Note";

  static final columnId = "id";
  static final columnTitle = "title";
  static final columnData = "data";

  // a singleton class so that only one instance is there for the complete application lifecycle
  DatabaseHelper._init(); //privatr constructor
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);

    return await openDatabase(path, version: _dbVersion, onCreate: _onCreateDB);
  }

  Future _onCreateDB(Database db, int version) {
    return db.execute('''
  CREATE TABLE $_tableName ( 
  $columnId INTEGER  PRIMARY KEY,
  $columnTitle TEXT NOT NULL,
  $columnData  TEXT)
  ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db
        .insert(_tableName, {'title': row['title'], 'data': row['data']});
  }

  Future<List<Note>> queryAll() async {
    Database db = await instance.database;
    List<Map> results = await db.query(_tableName);
    List<Note> noteList = [];
    // print("query data $results");
    results.forEach((element) {
      Note note = Note(
          id: element['id'], title: element['title'], data: element['data']);
      noteList.add(note);
    });
    //print(noteList);
    return noteList;
  }

  Future<List<Note>> searchQuery(String searchString) async {
    Database db = await instance.database;
    List<Map> results = await db.query(_tableName,
        where: '$columnTitle LIKE ? OR $columnData LIKE ?',
        whereArgs: ["%$searchString%", "%$searchString%"]);
    List<Note> noteList = [];
    print(" search query data $results \n");
    results.forEach((element) {
      Note note = Note(
          id: element['id'], title: element['title'], data: element['data']);
      noteList.add(note);
    });
    print(noteList);
    return noteList;
  }

  Future<Note> singleNote(int id) async {
    Database db = await instance.database;
    List<Map> notes = await db.query(_tableName,
        where: '${DatabaseHelper.columnId} = ?', whereArgs: [id]);
    Map<dynamic, dynamic> element = notes[0];
    Note note =
        Note(id: element['id'], title: element['title'], data: element['data']);
    return note;
  }

  Future update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];

    return await db.update(
        _tableName, {'title': row['title'], 'data': row['data']},
        where: '$columnId=?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return db.delete(_tableName, where: '$columnId=?', whereArgs: [id]);
  }
} //class closed
