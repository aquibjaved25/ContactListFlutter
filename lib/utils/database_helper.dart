import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutterappcontactassignment/model/contact_model.dart';

class DatabaseHelper {

  static DatabaseHelper _databaseHelper;    // Singleton DatabaseHelper
  static Database _database;                // Singleton Database

  String contactTable = 'contact_table';
  String colId = 'id';
  String colName = 'name';
  String colMobile = 'mobile';
  String colFavorite = 'favorite';
  String colLandline = 'landline';
  String colImagePath = 'imgpath';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {

    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {

    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'contacts.db';

    // Open/create the database at a given path
    var notesDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {

    await db.execute('CREATE TABLE $contactTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, '
        '$colMobile TEXT, $colFavorite INTEGER, $colLandline TEXT, $colImagePath TEXT)');
  }

  // Fetch Operation: Get all contactModel objects from database
  Future<List<Map<String, dynamic>>> getContactMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $contactTable order by $colFavorite ASC');
    var result = await db.query(contactTable, orderBy: '$colName ASC');
    return result;
  }

  // Fetch Operation: Get all contactModel objects from database
  Future<List<Map<String, dynamic>>> getFavoriteContactMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $contactTable order by $colFavorite ASC');
    var result = await db.query(contactTable, orderBy: '$colName ASC', where: '$colFavorite = ?',whereArgs: [1]);
    return result;
  }

  // Insert Operation: Insert a contactModel object to database
  Future<int> insertContact(ContactModel conactModel) async {
    Database db = await this.database;
    var result = await db.insert(contactTable, conactModel.toMap());
    return result;
  }

  // Update Operation: Update a contactModel object and save it to database
  Future<int> updateContact(ContactModel conactModel) async {
    var db = await this.database;
    var result = await db.update(contactTable, conactModel.toMap(), where: '$colId = ?', whereArgs: [conactModel.id]);
    return result;
  }

  // Delete Operation: Delete a contactModel object from database
  Future<int> deleteContact(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $contactTable WHERE $colId = $id');
    return result;
  }

  // Get number of contactModel objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $contactTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'contactModel List' [ List<contactModel> ]
  Future<List<ContactModel>> getContactList() async {

    var contactMapList = await getContactMapList(); // Get 'Map List' from database
    int count = contactMapList.length;         // Count the number of map entries in db table

    List<ContactModel> contactList = List<ContactModel>();
    // For loop to create a 'contactModel List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      contactList.add(ContactModel.fromMapObject(contactMapList[i]));
    }

    return contactList;
  }

  Future<List<ContactModel>> getFavoriteContactList() async {

    var contactMapList = await getFavoriteContactMapList(); // Get 'Map List' from database
    int count = contactMapList.length;         // Count the number of map entries in db table

    List<ContactModel> contactList = List<ContactModel>();
    // For loop to create a 'contactModel List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      contactList.add(ContactModel.fromMapObject(contactMapList[i]));
    }

    return contactList;
  }
}