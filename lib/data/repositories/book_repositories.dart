import 'package:library_books/data/datasources/local_database.dart';
import 'package:library_books/data/models/book_models.dart';

class BookRepository {
  /// ✅ جلب كل الكتب من قاعدة البيانات
  Future<List<BookModel>> getAllBooks() async {
    final books = await LocalDatabase.getAllBooks();
    return books;
  }

  /// ✅ إضافة كتاب جديد
  Future<void> addBook(BookModel book) async {
    await LocalDatabase.insertBook(book);
  }

  /// ✅ تعديل كتاب موجود
  Future<void> updateBook(BookModel book) async {
    await LocalDatabase.updateBook(book);
  }

  /// ✅ حذف كتاب
  Future<void> deleteBook(int id) async {
    await LocalDatabase.deleteBook(id);
  }

  /// ✅ البحث عن كتاب بالعنوان
  Future<List<BookModel>> searchBooks(String query) async {
    final db = await LocalDatabase.database;
    final result = await db.query(
      'books',
      where: 'title LIKE ? OR shortDescription LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return List.generate(result.length, (i) => BookModel.fromMap(result[i]));
  }

  /// ✅ ترتيب الكتب حسب تقييمها (Rating)
  Future<List<BookModel>> sortBooksByRating({bool ascending = false}) async {
    final db = await LocalDatabase.database;
    final result = await db.query(
      'books',
      orderBy: 'rating ${ascending ? 'ASC' : 'DESC'}',
    );
    return List.generate(result.length, (i) => BookModel.fromMap(result[i]));
  }
}
