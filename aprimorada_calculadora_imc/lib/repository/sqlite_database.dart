import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class SQLiteDatabase {
  
  static Database? db;

  Future<Database> obterDatabase() async {
    if (db == null){
      return await iniciarBancoDeDados();
    } else {
      return db!;
    }
  }

  Map<int, String> scripts = {
    1: '''  CREATE TABLE registros (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              peso REAL,
              altura REAL,
              imc REAL,
              classificacao TEXT,
              data TEXT
            );
    '''
  };

  Future<Database> iniciarBancoDeDados() async {
    db = 
    await openDatabase(
      path.join(await getDatabasesPath(), 'database.db'),
      version: scripts.length,
      onCreate: (Database db, int version) async {
        for (var i = 1; i <= scripts.length; i++){
          await db.execute(scripts[i]!);
          debugPrint(scripts[i]!);
        }
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        for (var i = oldVersion + 1; i <= scripts.length; i++){
          await db.execute(scripts[i]!);
          debugPrint(scripts[i]!);
        }
      }
    );
    return db!;
  }

}