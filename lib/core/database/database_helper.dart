import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'library_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE books (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        shortDescription TEXT,
        rating REAL,
        publishingHouseId INTEGER,
        isFavorite INTEGER,
        coverImagePath TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE authors (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        hometown TEXT,
        birthdate TEXT,
        profileImagePath TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE publishers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        address TEXT,
        phone TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE comments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bookId INTEGER,
        writerName TEXT,
        content TEXT,
        dateTime TEXT,
        likes INTEGER,
        dislikes INTEGER
      );
    ''');
  }
}
