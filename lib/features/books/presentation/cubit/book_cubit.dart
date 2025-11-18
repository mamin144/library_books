// استيراد مكتبة flutter_bloc - لإدارة الحالة (Cubit)
import 'package:flutter_bloc/flutter_bloc.dart';
// استيراد equatable - للمقارنة بين الحالات
import 'package:equatable/equatable.dart';
// استيراد BookModel - نموذج البيانات للكتاب
import 'package:library_books/features/books/data/models/book_models.dart';
// استيراد BookRepository - للوصول إلى قاعدة البيانات
import 'package:library_books/features/books/data/repositories/book_repositories.dart';

// ربط ملف book_state.dart مع هذا الملف
part 'book_state.dart';

// BookCubit: يدير حالة الكتب في التطبيق
// extends Cubit<BookState>: يستخدم Cubit لإدارة الحالة
class BookCubit extends Cubit<BookState> {
  // BookRepository: للوصول إلى قاعدة البيانات (CRUD operations)
  final BookRepository bookRepository;

  // Constructor: يأخذ BookRepository كمعامل
  // super(BookInitial()): يبدأ بالحالة الأولية
  BookCubit(this.bookRepository) : super(BookInitial());

  /// جلب كل الكتب من قاعدة البيانات
  Future<void> getAllBooks() async {
    try {
      // emit: إرسال حالة التحميل - لتظهر دائرة التحميل في الواجهة
      emit(BookLoading());
      // جلب الكتب من قاعدة البيانات (عملية async)
      final books = await bookRepository.getAllBooks();
      // emit: إرسال حالة النجاح مع قائمة الكتب - لتظهر الكتب في الواجهة
      emit(BookLoaded(books));
    } catch (e) {
      // في حالة الخطأ: إرسال حالة الخطأ مع رسالة
      emit(BookError('فشل في جلب الكتب: ${e.toString()}'));
    }
  }

  /// إضافة كتاب جديد إلى قاعدة البيانات
  Future<void> addBook(BookModel book) async {
    try {
      // إرسال حالة التحميل
      emit(BookLoading());
      // إضافة الكتاب إلى قاعدة البيانات
      await bookRepository.addBook(book);
      // إرسال رسالة نجاح
      emit(BookOperationSuccess('تم إضافة الكتاب بنجاح'));
      // إعادة جلب الكتب بعد الإضافة - لتحديث القائمة
      await getAllBooks();
    } catch (e) {
      // في حالة الخطأ: إرسال حالة الخطأ
      emit(BookError('فشل في إضافة الكتاب: ${e.toString()}'));
    }
  }

  /// تعديل كتاب موجود في قاعدة البيانات
  Future<void> updateBook(BookModel book) async {
    try {
      // إرسال حالة التحميل
      emit(BookLoading());
      // تعديل الكتاب في قاعدة البيانات
      await bookRepository.updateBook(book);
      // إرسال رسالة نجاح
      emit(BookOperationSuccess('تم تعديل الكتاب بنجاح'));
      // إعادة جلب الكتب بعد التعديل - لتحديث القائمة
      await getAllBooks();
    } catch (e) {
      // في حالة الخطأ: إرسال حالة الخطأ
      emit(BookError('فشل في تعديل الكتاب: ${e.toString()}'));
    }
  }

  /// حذف كتاب من قاعدة البيانات
  Future<void> deleteBook(int id) async {
    try {
      // إرسال حالة التحميل
      emit(BookLoading());
      // حذف الكتاب من قاعدة البيانات
      await bookRepository.deleteBook(id);
      // إرسال رسالة نجاح
      emit(BookOperationSuccess('تم حذف الكتاب بنجاح'));
      // إعادة جلب الكتب بعد الحذف - لتحديث القائمة
      await getAllBooks();
    } catch (e) {
      // في حالة الخطأ: إرسال حالة الخطأ
      emit(BookError('فشل في حذف الكتاب: ${e.toString()}'));
    }
  }

  /// البحث عن كتب في قاعدة البيانات
  Future<void> searchBooks(String query) async {
    try {
      // إذا كان البحث فارغاً: جلب كل الكتب
      if (query.isEmpty) {
        await getAllBooks();
        return; // الخروج من الدالة
      }
      // إرسال حالة التحميل
      emit(BookLoading());
      // البحث في قاعدة البيانات
      final books = await bookRepository.searchBooks(query);
      // إرسال النتائج
      emit(BookLoaded(books));
    } catch (e) {
      // في حالة الخطأ: إرسال حالة الخطأ
      emit(BookError('فشل في البحث: ${e.toString()}'));
    }
  }

  /// ترتيب الكتب حسب التقييم (من الأعلى للأقل أو العكس)
  Future<void> sortBooksByRating({bool ascending = false}) async {
    try {
      // إرسال حالة التحميل
      emit(BookLoading());
      // ترتيب الكتب من Repository
      final books =
          await bookRepository.sortBooksByRating(ascending: ascending);
      // إرسال الكتب المرتبة
      emit(BookLoaded(books));
    } catch (e) {
      // في حالة الخطأ: إرسال حالة الخطأ
      emit(BookError('فشل في ترتيب الكتب: ${e.toString()}'));
    }
  }
}
