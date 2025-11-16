import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:library_books/features/books/data/models/book_models.dart';
import 'package:library_books/features/books/data/repositories/book_repositories.dart';

part 'book_state.dart';

class BookCubit extends Cubit<BookState> {
  final BookRepository bookRepository;

  BookCubit(this.bookRepository) : super(BookInitial());

  /// جلب كل الكتب
  Future<void> getAllBooks() async {
    try {
      emit(BookLoading());
      final books = await bookRepository.getAllBooks();
      emit(BookLoaded(books));
    } catch (e) {
      emit(BookError('فشل في جلب الكتب: ${e.toString()}'));
    }
  }

  /// إضافة كتاب جديد
  Future<void> addBook(BookModel book) async {
    try {
      emit(BookLoading());
      await bookRepository.addBook(book);
      emit(BookOperationSuccess('تم إضافة الكتاب بنجاح'));
      // إعادة جلب الكتب بعد الإضافة
      await getAllBooks();
    } catch (e) {
      emit(BookError('فشل في إضافة الكتاب: ${e.toString()}'));
    }
  }

  /// تعديل كتاب
  Future<void> updateBook(BookModel book) async {
    try {
      emit(BookLoading());
      await bookRepository.updateBook(book);
      emit(BookOperationSuccess('تم تعديل الكتاب بنجاح'));
      // إعادة جلب الكتب بعد التعديل
      await getAllBooks();
    } catch (e) {
      emit(BookError('فشل في تعديل الكتاب: ${e.toString()}'));
    }
  }

  /// حذف كتاب
  Future<void> deleteBook(int id) async {
    try {
      emit(BookLoading());
      await bookRepository.deleteBook(id);
      emit(BookOperationSuccess('تم حذف الكتاب بنجاح'));
      // إعادة جلب الكتب بعد الحذف
      await getAllBooks();
    } catch (e) {
      emit(BookError('فشل في حذف الكتاب: ${e.toString()}'));
    }
  }

  /// البحث عن كتب
  Future<void> searchBooks(String query) async {
    try {
      if (query.isEmpty) {
        await getAllBooks();
        return;
      }
      emit(BookLoading());
      final books = await bookRepository.searchBooks(query);
      emit(BookLoaded(books));
    } catch (e) {
      emit(BookError('فشل في البحث: ${e.toString()}'));
    }
  }

  /// ترتيب الكتب حسب التقييم
  Future<void> sortBooksByRating({bool ascending = false}) async {
    try {
      emit(BookLoading());
      final books = await bookRepository.sortBooksByRating(ascending: ascending);
      emit(BookLoaded(books));
    } catch (e) {
      emit(BookError('فشل في ترتيب الكتب: ${e.toString()}'));
    }
  }
}

