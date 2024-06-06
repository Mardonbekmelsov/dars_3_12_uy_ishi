import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  LocalDatabase._singleton();

  static final LocalDatabase _localDatabase = LocalDatabase._singleton();

  Database? _database;

  factory LocalDatabase() {
    return _localDatabase;
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = '$databasePath/contact.db';

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    return await db.execute('''
      CREATE TABLE contacts (
        name TEXT NOT NULL,
        number TEXT NOT NULL
      );
    ''');
  }

  Future<void> addContact(String name, String number) async {
    var db = await database;
    print(name);
    print(number);
    await db.insert("contacts", {
      "name": name,
      "number": number,
    });
    print("success");
    getContacts();
  }

  Future<List<Map<String, dynamic>>> getContacts() async {
    var db = await database;

    var contacts = await db.query("contacts");

    // print(contacts);

    return contacts;
  }

  Future<void> deleteContact(String name, String number) async {
    var db = await database;

    await db.delete("contacts", where: "name = '$name' and number= '$number'");
  }

  Future<void> editContact(
      String name, String number, String newName, String newNumber) async {
    var db = await database;

    Map<String, dynamic> row = {"name": newName, "number": newNumber};
    db.update("contacts", row, where: "name = '$name' and number= '$number'");
  }
}
