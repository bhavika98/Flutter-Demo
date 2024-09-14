import 'dart:async';
import 'dart:io';

import 'package:flutter_demo/model/user_data.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _dbName = 'userDatabase.db';
  static const _dbVersion = 1;

  static const _tableUser = "user";

  static const _keyId = "id";
  static const _keyType = "type";
  static const _keyName = "name";
  static const _keyContact = "contact";
  static const _keyImage = "image";
  static const _keyVideo = "video";

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Make _database nullable
  static Database? _database;

  // Getter to initialize the database if it's null
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initiateDatabase();
    return _database!;
  }

  // Initiate the database
  Future<Database> _initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  // Create table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableUser (
        $_keyId INTEGER PRIMARY KEY,
        $_keyType INTEGER,
        $_keyName TEXT,
        $_keyContact TEXT,
        $_keyImage TEXT,
        $_keyVideo TEXT
      )
    ''');
  }

  // Convert UserData to map
  Map<String, dynamic> toMap(UserData object) {
    return <String, dynamic>{
      _keyId: object.id,
      _keyType: object.type,
      _keyName: object.name,
      _keyContact: object.contact,
      _keyImage: object.image,
      _keyVideo: object.video,
    };
  }

  // Convert map to UserData
  UserData fromMap(Map<String, dynamic> query) {
    return UserData(
      id: query[_keyId],
      type: query[_keyType],
      name: query[_keyName],
      contact: query[_keyContact],
      image: query[_keyImage],
      video: query[_keyVideo],
    );
  }

  // Convert list of maps to list of UserData
  List<UserData> fromList(List<Map<String, dynamic>> query) {
    return query.map((map) => fromMap(map)).toList();
  }

  // Insert user data
  Future<int> insert(UserData userData) async {
    Database db = await database; // Use the getter
    Map<String, dynamic> row = toMap(userData);
    return await db.insert(_tableUser, row);
  }

  // Query all users
  Future<List<UserData>> queryAll() async {
    Database db = await database; // Use the getter
    List<Map<String, dynamic>> maps = await db.query(_tableUser);
    return fromList(maps);
  }

  // Update user data
  Future<int> update(UserData userData) async {
    Database db = await database; // Use the getter
    Map<String, dynamic> row = toMap(userData);
    int? id = userData.id;
    return await db.update(_tableUser, row, where: '$_keyId=?', whereArgs: [id]);
  }

  // Delete user by id
  Future<int> delete(int id) async {
    Database db = await database; // Use the getter
    return await db.delete(_tableUser, where: '$_keyId=?', whereArgs: [id]);
  }
}

