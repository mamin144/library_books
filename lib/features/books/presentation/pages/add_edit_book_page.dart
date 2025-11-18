// استيراد Material Design widgets
import 'package:flutter/material.dart';
// استيراد flutter_bloc لإدارة الحالة
import 'package:flutter_bloc/flutter_bloc.dart';
// استيراد BookModel - نموذج البيانات
import 'package:library_books/features/books/data/models/book_models.dart';
// استيراد BookCubit - لإدارة حالة الكتب
import 'package:library_books/features/books/presentation/cubit/book_cubit.dart';

// AddEditBookPage: Widget ديناميكي - صفحة إضافة أو تعديل كتاب
class AddEditBookPage extends StatefulWidget {
  // book: إذا كان null = إضافة جديد، إذا كان موجود = تعديل
  final BookModel? book;

  // Constructor ثابت
  const AddEditBookPage({super.key, this.book});

  @override
  // إنشاء State للـ widget
  State<AddEditBookPage> createState() => _AddEditBookPageState();
}

// _AddEditBookPageState: يدير حالة النموذج
class _AddEditBookPageState extends State<AddEditBookPage> {
  // _formKey: مفتاح للتحقق من صحة النموذج
  final _formKey = GlobalKey<FormState>();
  // _titleController: للتحكم في حقل العنوان
  final _titleController = TextEditingController();
  // _descriptionController: للتحكم في حقل الوصف
  final _descriptionController = TextEditingController();
  // _ratingController: للتحكم في حقل التقييم
  final _ratingController = TextEditingController();
  // _publishingHouseIdController: للتحكم في حقل معرف دار النشر
  final _publishingHouseIdController = TextEditingController();
  // _coverImagePathController: للتحكم في حقل رابط صورة الغلاف
  final _coverImagePathController = TextEditingController();
  // _isFavorite: هل الكتاب في المفضلة أم لا
  bool _isFavorite = false;

  @override
  // initState: يتم استدعاؤها مرة واحدة عند إنشاء الـ widget
  void initState() {
    super.initState();
    // إذا كان هناك كتاب (تعديل): ملء الحقول بالبيانات الموجودة
    if (widget.book != null) {
      // ملء حقل العنوان
      _titleController.text = widget.book!.title;
      // ملء حقل الوصف
      _descriptionController.text = widget.book!.shortDescription;
      // ملء حقل التقييم (تحويل من رقم إلى نص)
      _ratingController.text = widget.book!.rating.toString();
      // ملء حقل معرف دار النشر (تحويل من رقم إلى نص)
      _publishingHouseIdController.text =
          widget.book!.publishingHouseId.toString();
      // ملء حقل رابط الصورة (إذا كان موجوداً)
      _coverImagePathController.text = widget.book!.coverImagePath ?? '';
      // تعيين حالة المفضلة
      _isFavorite = widget.book!.isFavorite;
    }
  }

  @override
  // dispose: تنظيف الموارد عند إغلاق الصفحة
  void dispose() {
    // تحرير جميع Controllers من الذاكرة
    _titleController.dispose();
    _descriptionController.dispose();
    _ratingController.dispose();
    _publishingHouseIdController.dispose();
    _coverImagePathController.dispose();
    super.dispose();
  }

  // _saveBook: دالة لحفظ الكتاب (إضافة أو تعديل)
  void _saveBook(BuildContext context) {
    // validate: التحقق من صحة جميع الحقول
    if (_formKey.currentState!.validate()) {
      // إنشاء كائن BookModel من البيانات المدخلة
      final book = BookModel(
        // id: إذا كان تعديل = نفس الـ id، إذا كان إضافة = null
        id: widget.book?.id,
        // title: العنوان بعد إزالة المسافات الزائدة
        title: _titleController.text.trim(),
        // shortDescription: الوصف بعد إزالة المسافات الزائدة
        shortDescription: _descriptionController.text.trim(),
        // rating: تحويل التقييم من نص إلى رقم عشري
        rating: double.parse(_ratingController.text),
        // publishingHouseId: تحويل معرف دار النشر من نص إلى رقم
        publishingHouseId: int.parse(_publishingHouseIdController.text),
        // isFavorite: حالة المفضلة
        isFavorite: _isFavorite,
        // coverImagePath: رابط الصورة (إذا كان فارغاً = null)
        coverImagePath: _coverImagePathController.text.trim().isEmpty
            ? null
            : _coverImagePathController.text.trim(),
      );

      // الحصول على BookCubit من context
      final bookCubit = BlocProvider.of<BookCubit>(context);
      // إذا كان book null = إضافة جديد
      if (widget.book == null) {
        // استدعاء addBook لإضافة الكتاب
        bookCubit.addBook(book);
      } else {
        // إذا كان book موجود = تعديل
        // استدعاء updateBook لتعديل الكتاب
        bookCubit.updateBook(book);
      }

      // العودة إلى الصفحة السابقة
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold: الهيكل الأساسي للصفحة
    return Scaffold(
      // AppBar: شريط العنوان
      appBar: AppBar(
        // title: العنوان (يختلف حسب الإضافة أو التعديل)
        title: Text(widget.book == null ? 'إضافة كتاب جديد' : 'تعديل كتاب'),
        // centerTitle: توسيط العنوان
        centerTitle: true,
      ),
      // body: محتوى الصفحة
      body: SingleChildScrollView(
        // padding: مسافات حول المحتوى
        padding: const EdgeInsets.all(16),
        // Form: نموذج للتحقق من صحة البيانات
        child: Form(
          // key: ربط النموذج بـ _formKey للتحقق
          key: _formKey,
          // Column: ترتيب الحقول عمودياً
          child: Column(
            // crossAxisAlignment: توسيط الحقول أفقياً
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // عنوان الكتاب
              TextFormField(
                // controller: ربط الحقل بـ _titleController
                controller: _titleController,
                // decoration: تصميم الحقل
                decoration: const InputDecoration(
                  // labelText: نص فوق الحقل
                  labelText: 'عنوان الكتاب *',
                  // border: تصميم الحدود
                  border: OutlineInputBorder(),
                  // prefixIcon: أيقونة في بداية الحقل
                  prefixIcon: Icon(Icons.title),
                ),
                // validator: دالة التحقق من صحة البيانات
                validator: (value) {
                  // إذا كان الحقل فارغاً: رسالة خطأ
                  if (value == null || value.trim().isEmpty) {
                    return 'يرجى إدخال عنوان الكتاب';
                  }
                  // إذا كان صحيحاً: null (لا يوجد خطأ)
                  return null;
                },
              ),
              const SizedBox(height: 16), // مسافة بين الحقول
              // وصف الكتاب
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'وصف الكتاب *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                // maxLines: عدد الأسطر (4 أسطر)
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'يرجى إدخال وصف الكتاب';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // التقييم
              TextFormField(
                controller: _ratingController,
                decoration: const InputDecoration(
                  labelText: 'التقييم (0.0 - 5.0) *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.star),
                ),
                // keyboardType: نوع لوحة المفاتيح (أرقام)
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'يرجى إدخال التقييم';
                  }
                  // tryParse: محاولة تحويل النص إلى رقم عشري
                  final rating = double.tryParse(value);
                  // إذا كان التحويل فشل أو الرقم خارج النطاق: خطأ
                  if (rating == null || rating < 0 || rating > 5) {
                    return 'التقييم يجب أن يكون بين 0.0 و 5.0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // معرف دار النشر
              TextFormField(
                controller: _publishingHouseIdController,
                decoration: const InputDecoration(
                  labelText: 'معرف دار النشر *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.business),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'يرجى إدخال معرف دار النشر';
                  }
                  // tryParse: محاولة تحويل النص إلى رقم صحيح
                  if (int.tryParse(value) == null) {
                    return 'يرجى إدخال رقم صحيح';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // رابط صورة الغلاف
              TextFormField(
                controller: _coverImagePathController,
                decoration: const InputDecoration(
                  labelText: 'رابط صورة الغلاف (اختياري)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.image),
                ),
                // لا يوجد validator لأن الحقل اختياري
              ),
              const SizedBox(height: 16),
              // المفضلة
              CheckboxListTile(
                // title: نص بجانب Checkbox
                title: const Text('إضافة إلى المفضلة'),
                // value: قيمة Checkbox (true/false)
                value: _isFavorite,
                // onChanged: عند تغيير القيمة
                onChanged: (value) {
                  // setState: تحديث الواجهة
                  setState(() {
                    // تحديث _isFavorite بالقيمة الجديدة
                    _isFavorite = value ?? false;
                  });
                },
                // controlAffinity: موقع Checkbox (في البداية)
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 24),
              // زر الحفظ
              ElevatedButton(
                // onPressed: عند الضغط: حفظ الكتاب
                onPressed: () => _saveBook(context),
                // style: تصميم الزر
                style: ElevatedButton.styleFrom(
                  // padding: مسافات داخل الزر
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  // shape: شكل الزر (زوايا مستديرة)
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                // child: محتوى الزر (النص)
                child: Text(
                  // النص يختلف حسب الإضافة أو التعديل
                  widget.book == null ? 'إضافة الكتاب' : 'حفظ التعديلات',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
