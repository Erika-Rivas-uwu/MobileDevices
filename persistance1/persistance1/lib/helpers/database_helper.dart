import 'dart:io';

import 'package:persistance1/models/cat_model.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
// ignore: duplicate_import
import "dart:io";

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  //Metodo asincrono que regresa un Future de tipo Database, si la base de datos no ha sido creada llama al metodo _init..., primera vez que se corre se genera luego ya no
  Future<Database> get database async => _database ??= await _initDatase();

  Future<Database> _initDatase() async {
    //specify a location in your phone to store the data base
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    //directorio donde se guardan los archivos
    String path = join(documentsDirectory.path, 'animals.db');
    //si no existe openDatabase crea la base de datos
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
        //single ' tres veces para escribir en multilinea
        '''
      CREATE TABLE cats (
        id INTEGER PRIMARY KEY,
        race TEXT,
        name TEXT
      )
      ''');
  }

  Future<List<Cat>> getCats() async {
    Database db = await instance.database;
    var cats = await db.query('cats', orderBy: "race");

    //si no es empty ? (entonces)... has esto :(else) si no se cumple regresame la lista vacia
    //Ternalia dicen
    List<Cat> catsList =
        cats.isNotEmpty ? cats.map((e) => Cat.fromMap(e)).toList() : [];
    return catsList;
  }

  Future<int> add(Cat cat) async {
    //esperar hasta la conección
    Database db = await instance.database;
    return await db.insert('cats', cat.toMap());
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete('cats', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Cat cat) async {
    Database db = await instance.database;
    return await db
        .update('cats', cat.toMap(), where: 'id = ?', whereArgs: [cat.id]);
  }
}
