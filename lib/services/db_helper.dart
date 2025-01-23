import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tot_app/dog_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('saved_dogs.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE saved_dogs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        breed TEXT,
        imageUrl TEXT,
        breedGroup TEXT,
        description TEXT
      )
    ''');
  }

  Future<int> saveDog(Dog dog) async {
    final db = await instance.database;
    return await db.insert('saved_dogs', dog.toMap());
  }

  Future<List<Dog>> getSavedDogs() async {
    final db = await instance.database;
    final maps = await db.query('saved_dogs');
    return maps.map((map) => Dog(
      id: map['id'] as int,
      name: map['name'] as String,
      breed: map['breed'] as String,
      imageUrl: map['imageUrl'] as String?,
      breedGroup: map['breedGroup'] as String?,
      description: map['description'] as String?,
    )).toList();
  }

  Future<int> removeSavedDog(int id) async {
    final db = await instance.database;
    return await db.delete(
      'saved_dogs', 
      where: 'id = ?', 
      whereArgs: [id]
    );
  }
}