// استيراد Material Design widgets
import 'package:flutter/material.dart';
// استيراد flutter_bloc لإدارة الحالة
import 'package:flutter_bloc/flutter_bloc.dart';
// استيراد BookModel - نموذج البيانات
import 'package:library_books/features/books/data/models/book_models.dart';
// استيراد BookRepository - للوصول إلى قاعدة البيانات
import 'package:library_books/features/books/data/repositories/book_repositories.dart';
// استيراد BookCubit - لإدارة حالة الكتب
import 'package:library_books/features/books/presentation/cubit/book_cubit.dart';

// استيراد BookCard - widget لعرض بطاقة الكتاب
import 'package:library_books/features/books/presentation/widgets/book_card.dart';
// استيراد AddEditBookPage - صفحة إضافة/تعديل كتاب
import 'package:library_books/features/books/presentation/pages/add_edit_book_page.dart';

// BooksListPage: Widget ثابت (لا يحتاج state) - يغلف BlocProvider
class BooksListPage extends StatelessWidget {
  // Constructor ثابت
  const BooksListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // BlocProvider: يوفر BookCubit لكل الـ widgets تحته
    return BlocProvider(
      // create: ينشئ BookCubit عند أول استخدام
      // ..getAllBooks(): يستدعي getAllBooks فوراً عند الإنشاء
      create: (context) => BookCubit(BookRepository())..getAllBooks(),
      // child: الصفحة الفعلية التي ستستخدم BookCubit
      child: const BooksListView(),
    );
  }
}

// BooksListView: Widget ديناميكي (يحتاج state) - لإدارة البحث والترتيب
class BooksListView extends StatefulWidget {
  // Constructor ثابت
  const BooksListView({super.key});

  @override
  // إنشاء State للـ widget
  State<BooksListView> createState() => _BooksListViewState();
}

// _BooksListViewState: يدير حالة البحث والترتيب
class _BooksListViewState extends State<BooksListView> {
  // TextEditingController: للتحكم في حقل البحث
  final TextEditingController _searchController = TextEditingController();
  // _sortAscending: هل الترتيب تصاعدي (true) أم تنازلي (false)
  bool _sortAscending = false;

  @override
  // dispose: تنظيف الموارد عند إغلاق الصفحة
  void dispose() {
    // تحرير TextEditingController من الذاكرة
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold: الهيكل الأساسي للصفحة (AppBar, Body, FAB)
    return Scaffold(
      // AppBar: شريط العنوان في أعلى الصفحة
      appBar: AppBar(
        // عنوان الصفحة
        title: const Text('مكتبة الكتب'),
        // توسيط العنوان
        centerTitle: true,
        // actions: أزرار في شريط العنوان
        actions: [
          // زر الترتيب
          IconButton(
            // أيقونة الترتيب
            icon: const Icon(Icons.sort),
            // عند الضغط: ترتيب الكتب حسب التقييم
            onPressed: () {
              // قراءة BookCubit من context واستدعاء sortBooksByRating
              context.read<BookCubit>().sortBooksByRating(
                    ascending: _sortAscending,
                  );
              // تحديث _sortAscending (تبديل بين تصاعدي وتنازلي)
              setState(() {
                _sortAscending = !_sortAscending;
              });
            },
            // tooltip: نص يظهر عند الضغط المطول
            tooltip: 'ترتيب حسب التقييم',
          ),
        ],
      ),
      // body: محتوى الصفحة
      body: Column(
        children: [
          // شريط البحث
          Padding(
            // padding: مسافات حول حقل البحث
            padding: const EdgeInsets.all(16),
            // TextField: حقل إدخال النص
            child: TextField(
              // controller: للتحكم في النص المدخل
              controller: _searchController,
              // decoration: تصميم الحقل
              decoration: InputDecoration(
                // hintText: نص توضيحي داخل الحقل
                hintText: 'ابحث عن كتاب...',
                // prefixIcon: أيقونة في بداية الحقل
                prefixIcon: const Icon(Icons.search),
                // suffixIcon: أيقونة في نهاية الحقل (زر مسح)
                // يظهر فقط إذا كان هناك نص في الحقل
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        // أيقونة X للمسح
                        icon: const Icon(Icons.clear),
                        // عند الضغط: مسح النص وجلب كل الكتب
                        onPressed: () {
                          // مسح النص من الحقل
                          _searchController.clear();
                          // جلب كل الكتب
                          context.read<BookCubit>().getAllBooks();
                        },
                      )
                    : null, // لا يظهر إذا كان الحقل فارغاً
                // border: تصميم الحدود
                border: OutlineInputBorder(
                  // borderRadius: جعل الزوايا مستديرة
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              // onChanged: عند تغيير النص في الحقل
              onChanged: (value) {
                // البحث في الكتب
                context.read<BookCubit>().searchBooks(value);
              },
            ),
          ),
          // قائمة الكتب
          // Expanded: يأخذ المساحة المتبقية من الشاشة
          Expanded(
            // BlocConsumer: يجمع بين BlocListener و BlocBuilder
            // listener: للاستماع للتغييرات (مثل رسائل النجاح/الخطأ)
            // builder: لبناء الواجهة حسب الحالة
            child: BlocConsumer<BookCubit, BookState>(
              // listener: يستمع للتغييرات في الحالة
              listener: (context, state) {
                // إذا كانت الحالة خطأ: عرض رسالة خطأ
                if (state is BookError) {
                  // ScaffoldMessenger: لعرض رسائل في أسفل الشاشة
                  ScaffoldMessenger.of(context).showSnackBar(
                    // SnackBar: رسالة منبثقة
                    SnackBar(
                      // محتوى الرسالة
                      content: Text(state.message),
                      // لون خلفية أحمر للخطأ
                      backgroundColor: Colors.red,
                    ),
                  );
                }
                // إذا كانت الحالة نجاح عملية: عرض رسالة نجاح
                else if (state is BookOperationSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      // لون خلفية أخضر للنجاح
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              // builder: يبني الواجهة حسب الحالة الحالية
              builder: (context, state) {
                // إذا كانت الحالة تحميل: عرض دائرة تحميل
                if (state is BookLoading) {
                  return const Center(
                    // CircularProgressIndicator: دائرة التحميل
                    child: CircularProgressIndicator(),
                  );
                }
                // إذا كانت الحالة نجاح جلب البيانات
                else if (state is BookLoaded) {
                  // إذا كانت القائمة فارغة: عرض رسالة
                  if (state.books.isEmpty) {
                    return const Center(
                      child: Column(
                        // توسيط المحتوى عمودياً
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // أيقونة كتاب كبير
                          Icon(Icons.book_outlined,
                              size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          // نص "لا توجد كتب"
                          Text(
                            'لا توجد كتب',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  // إذا كانت هناك كتب: عرض القائمة
                  return RefreshIndicator(
                    // onRefresh: عند سحب الصفحة للأسفل (pull to refresh)
                    onRefresh: () async {
                      // إعادة جلب الكتب
                      context.read<BookCubit>().getAllBooks();
                    },
                    // ListView.builder: بناء قائمة ديناميكية
                    child: ListView.builder(
                      // itemCount: عدد العناصر في القائمة
                      itemCount: state.books.length,
                      // itemBuilder: بناء كل عنصر في القائمة
                      itemBuilder: (context, index) {
                        // جلب الكتاب من القائمة
                        final book = state.books[index];
                        // عرض بطاقة الكتاب
                        return BookCard(
                          // تمرير بيانات الكتاب
                          book: book,
                          // onTap: عند الضغط على البطاقة (يمكن فتح تفاصيل)
                          onTap: () {
                            // يمكن فتح صفحة تفاصيل الكتاب
                          },
                          // onEdit: عند الضغط على زر التعديل
                          onEdit: () {
                            // حفظ BookCubit في متغير
                            final bookCubit = context.read<BookCubit>();
                            // الانتقال إلى صفحة التعديل
                            Navigator.push(
                              context,
                              // MaterialPageRoute: طريقة الانتقال
                              MaterialPageRoute(
                                // builder: بناء الصفحة الجديدة
                                builder: (_) => BlocProvider.value(
                                  // value: تمرير BookCubit الموجود (لا إنشاء جديد)
                                  value: bookCubit,
                                  // child: صفحة التعديل مع بيانات الكتاب
                                  child: AddEditBookPage(book: book),
                                ),
                              ),
                            );
                          },
                          // onDelete: عند الضغط على زر الحذف
                          onDelete: () {
                            // عرض حوار تأكيد الحذف
                            _showDeleteDialog(context, book);
                          },
                        );
                      },
                    ),
                  );
                }
                // إذا كانت الحالة خطأ: عرض رسالة خطأ مع زر إعادة المحاولة
                else if (state is BookError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // أيقونة خطأ
                        const Icon(Icons.error_outline,
                            size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        // رسالة الخطأ
                        Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        // زر إعادة المحاولة
                        ElevatedButton(
                          // عند الضغط: إعادة جلب الكتب
                          onPressed: () {
                            context.read<BookCubit>().getAllBooks();
                          },
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  );
                }
                // الحالة الافتراضية: رسالة ترحيبية
                return const Center(
                  child: Text('ابدأ بإضافة كتاب جديد'),
                );
              },
            ),
          ),
        ],
      ),
      // floatingActionButton: زر عائم في أسفل الصفحة
      floatingActionButton: FloatingActionButton.extended(
        // onPressed: عند الضغط: فتح صفحة إضافة كتاب جديد
        onPressed: () {
          // حفظ BookCubit في متغير
          final bookCubit = context.read<BookCubit>();
          // الانتقال إلى صفحة الإضافة
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                // تمرير BookCubit الموجود
                value: bookCubit,
                // صفحة الإضافة (بدون book = إضافة جديد)
                child: const AddEditBookPage(),
              ),
            ),
          );
        },
        // icon: أيقونة + في الزر
        icon: const Icon(Icons.add),
        // label: نص "إضافة كتاب"
        label: const Text('إضافة كتاب'),
      ),
    );
  }

  // _showDeleteDialog: دالة لعرض حوار تأكيد الحذف
  void _showDeleteDialog(BuildContext context, BookModel book) {
    // showDialog: عرض حوار منبثق
    showDialog(
      context: context,
      // builder: بناء محتوى الحوار
      builder: (context) => AlertDialog(
        // title: عنوان الحوار
        title: const Text('حذف الكتاب'),
        // content: محتوى الحوار (رسالة التأكيد)
        content: Text('هل أنت متأكد من حذف "${book.title}"؟'),
        // actions: أزرار الحوار
        actions: [
          // زر الإلغاء
          TextButton(
            // عند الضغط: إغلاق الحوار
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          // زر الحذف
          TextButton(
            // عند الضغط: حذف الكتاب وإغلاق الحوار
            onPressed: () {
              // حذف الكتاب من قاعدة البيانات
              context.read<BookCubit>().deleteBook(book.id!);
              // إغلاق الحوار
              Navigator.pop(context);
            },
            // style: لون أحمر للزر
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}
