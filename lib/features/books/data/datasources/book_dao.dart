import 'package:library_books/features/books/data/models/book_models.dart';
import 'package:library_books/core/database/database_helper.dart';

class BookDao {
  final dbHelper = DatabaseHelper();

  Future<int> insertBook(BookModel book) async {
    final db = await dbHelper.database;
    return await db.insert('books', book.toMap());
  }

  Future<List<BookModel>> getAllBooks() async {
    final db = await dbHelper.database;
    final result = await db.query('books');
    return result.map((map) => BookModel.fromMap(map)).toList();
  }

  Future<int> updateBook(BookModel book) async {
    final db = await dbHelper.database;
    return await db
        .update('books', book.toMap(), where: 'id = ?', whereArgs: [book.id]);
  }

  Future<int> deleteBook(int id) async {
    final db = await dbHelper.database;
    return await db.delete('books', where: 'id = ?', whereArgs: [id]);
  }
}

