import 'package:library_books/data/models/book_models.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabase {
  static Database? _database;

  static const _dbName = 'library.db';
  static const _dbVersion = 1;

  /// ✅ 1. فتح أو إنشاء قاعدة البيانات
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  /// ✅ 2. إنشاء الجداول
  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE publishers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        address TEXT,
        phone TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE authors (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        hometown TEXT,
        birthdate TEXT,
        profileImagePath TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE books (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        shortDescription TEXT,
        rating REAL,
        publishingHouseId INTEGER,
        isFavorite INTEGER,
        coverImagePath TEXT
      )
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
      )
    ''');
  }

  /// ✅ 3. إضافة كتاب جديد
  static Future<int> insertBook(BookModel book) async {
    final db = await database;
    return await db.insert('books', book.toMap());
  }

  /// ✅ 4. جلب كل الكتب
  static Future<List<BookModel>> getAllBooks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('books');
    return List.generate(maps.length, (i) => BookModel.fromMap(maps[i]));
  }

  /// ✅ 5. تحديث كتاب
  static Future<int> updateBook(BookModel book) async {
    final db = await database;
    return await db.update(
      'books',
      book.toMap(),
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }

  /// ✅ 6. حذف كتاب
  static Future<int> deleteBook(int id) async {
    final db = await database;
    return await db.delete('books', where: 'id = ?', whereArgs: [id]);
  }
}
