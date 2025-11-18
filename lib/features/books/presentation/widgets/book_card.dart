// استيراد Material Design widgets
import 'package:flutter/material.dart';
// استيراد BookModel - نموذج البيانات
import 'package:library_books/features/books/data/models/book_models.dart';

// BookCard: Widget ثابت - بطاقة لعرض معلومات الكتاب
class BookCard extends StatelessWidget {
  // book: بيانات الكتاب المراد عرضها
  final BookModel book;
  // onTap: دالة يتم استدعاؤها عند الضغط على البطاقة (اختياري)
  final VoidCallback? onTap;
  // onDelete: دالة يتم استدعاؤها عند الضغط على زر الحذف (اختياري)
  final VoidCallback? onDelete;
  // onEdit: دالة يتم استدعاؤها عند الضغط على زر التعديل (اختياري)
  final VoidCallback? onEdit;

  // Constructor ثابت
  const BookCard({
    super.key,
    required this.book, // book مطلوب
    this.onTap, // باقي المعاملات اختيارية
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    // Card: بطاقة Material Design
    return Card(
      // margin: مسافات خارج البطاقة
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      // elevation: ظل البطاقة (لإعطاء عمق)
      elevation: 2,
      // InkWell: يجعل البطاقة قابلة للضغط مع تأثير مائي
      child: InkWell(
        // onTap: عند الضغط على البطاقة
        onTap: onTap,
        // borderRadius: جعل الزوايا مستديرة
        borderRadius: BorderRadius.circular(12),
        // child: محتوى البطاقة
        child: Padding(
          // padding: مسافات داخل البطاقة
          padding: const EdgeInsets.all(16),
          // Column: ترتيب المحتوى عمودياً
          child: Column(
            // crossAxisAlignment: محاذاة المحتوى من البداية (يسار)
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row: ترتيب الصورة والمعلومات أفقياً
              Row(
                children: [
                  // صورة الغلاف
                  Container(
                    // width: عرض الصورة
                    width: 80,
                    // height: ارتفاع الصورة
                    height: 120,
                    // decoration: تصميم الحاوية (لون، شكل، صورة)
                    decoration: BoxDecoration(
                      // color: لون خلفية (إذا لم تكن هناك صورة)
                      color: Colors.grey[300],
                      // borderRadius: زوايا مستديرة
                      borderRadius: BorderRadius.circular(8),
                      // image: صورة من الإنترنت (إذا كانت موجودة)
                      image: book.coverImagePath != null
                          ? DecorationImage(
                              // NetworkImage: تحميل صورة من رابط
                              image: NetworkImage(book.coverImagePath!),
                              // fit: ملء الحاوية بالكامل
                              fit: BoxFit.cover,
                              // onError: عند فشل التحميل (لا نفعل شيء)
                              onError: (_, __) {},
                            )
                          : null, // لا توجد صورة
                    ),
                    // child: إذا لم تكن هناك صورة، عرض أيقونة كتاب
                    child: book.coverImagePath == null
                        ? const Icon(Icons.book, size: 40, color: Colors.grey)
                        : null,
                  ),
                  const SizedBox(width: 16), // مسافة بين الصورة والمعلومات
                  // معلومات الكتاب
                  // Expanded: يأخذ المساحة المتبقية
                  Expanded(
                    child: Column(
                      // crossAxisAlignment: محاذاة من البداية
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text: عنوان الكتاب
                        Text(
                          book.title,
                          style: const TextStyle(
                            fontSize: 18, // حجم الخط
                            fontWeight: FontWeight.bold, // خط عريض
                          ),
                          // maxLines: أقصى عدد أسطر (2)
                          maxLines: 2,
                          // overflow: إذا زاد النص، يظهر "..."
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8), // مسافة
                        // Text: وصف الكتاب
                        Text(
                          book.shortDescription,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600], // لون رمادي
                          ),
                          maxLines: 3, // أقصى 3 أسطر
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        // التقييم
                        // Row: ترتيب الأيقونة والرقم أفقياً
                        Row(
                          children: [
                            // Icon: أيقونة نجمة ذهبية
                            const Icon(Icons.star,
                                color: Colors.amber, size: 20),
                            const SizedBox(width: 4), // مسافة صغيرة
                            // Text: رقم التقييم (رقم عشري واحد)
                            Text(
                              book.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600, // خط شبه عريض
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // زر المفضلة
                        // if: يظهر فقط إذا كان الكتاب في المفضلة
                        if (book.isFavorite)
                          Container(
                            // padding: مسافات داخل الحاوية
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            // decoration: تصميم الحاوية (لون خلفية، زوايا)
                            decoration: BoxDecoration(
                              color: Colors.red[100], // لون أحمر فاتح
                              borderRadius: BorderRadius.circular(12),
                            ),
                            // child: محتوى الحاوية (أيقونة + نص)
                            child: const Row(
                              // mainAxisSize: يأخذ أقل مساحة ممكنة
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Icon: أيقونة قلب أحمر
                                Icon(Icons.favorite,
                                    color: Colors.red, size: 16),
                                SizedBox(width: 4),
                                // Text: نص "مفضل"
                                Text(
                                  'مفضل',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12), // مسافة قبل الأزرار
              // أزرار الإجراءات
              // Row: ترتيب الأزرار أفقياً
              Row(
                // mainAxisAlignment: محاذاة من النهاية (يمين)
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // زر التعديل
                  // if: يظهر فقط إذا تم تمرير onEdit
                  if (onEdit != null)
                    IconButton(
                      // icon: أيقونة تعديل زرقاء
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      // onPressed: عند الضغط: استدعاء onEdit
                      onPressed: onEdit,
                      // tooltip: نص يظهر عند الضغط المطول
                      tooltip: 'تعديل',
                    ),
                  // زر الحذف
                  // if: يظهر فقط إذا تم تمرير onDelete
                  if (onDelete != null)
                    IconButton(
                      // icon: أيقونة حذف حمراء
                      icon: const Icon(Icons.delete, color: Colors.red),
                      // onPressed: عند الضغط: استدعاء onDelete
                      onPressed: onDelete,
                      tooltip: 'حذف',
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
