import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class SQLDB {
  Database? _db;
  List<Map>? _notes;
  
  Future<Database?> get db async {
    if (_db == null) {
      _db = await initalDB();
      return _db;
    } else {
      return _db;
    }
  }

  initalDB() async {
    String databasePath = await getDatabasesPath();
    String dbPath = path.join(databasePath, 'Note.db');
    Database myDataBase =
        await openDatabase(dbPath, version: 1, onCreate: _createDB);
    return myDataBase;
  }

  FutureOr<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Notes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      note TEXT,
      title TEXT
      )
    ''');

    // ignore: avoid_print
    print("Database created succefully==========");
  }

  insertData(String title,String body) async {
    Database? myDB = await db;
    int res = await myDB!.rawInsert("insert into Notes (title,note) values ('$title','$body')");
    return res;
  }
  updateData(int id,String title,String body) async {
    Database? myDB = await db;
    int res = await myDB!.rawUpdate("UPDATE Notes SET title='$title',note = '$body' WHERE id=$id"); 
    return res;
  }
  deleteData(int id) async {
    Database? myDB = await db;
    int res = await myDB!.rawDelete("DELETE FROM Notes WHERE id=$id");
    return res;
  }
  readData()async{
    Database? myDB= await db;
    List<Map> res= await myDB!.rawQuery("SELECT * FROM Notes");
    return res;
  }

}
