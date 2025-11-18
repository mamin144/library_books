// استيراد Material Design widgets
import 'package:flutter/material.dart';
// استيراد BooksListPage - الصفحة الرئيسية للتطبيق
import 'package:library_books/features/books/presentation/pages/books_list_page.dart';

// main: نقطة البداية في التطبيق - يتم استدعاؤها عند تشغيل التطبيق
void main() {
  // runApp: تشغيل التطبيق - يأخذ Widget كجذر للتطبيق
  runApp(const MainApp());
}

// MainApp: Widget الجذر للتطبيق - يغلف كل التطبيق
class MainApp extends StatelessWidget {
  // Constructor ثابت
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp: Widget أساسي في Flutter - يوفر Material Design
    return MaterialApp(
      // title: اسم التطبيق (يظهر في قائمة التطبيقات المفتوحة)
      title: 'مكتبة الكتب',
      // debugShowCheckedModeBanner: إخفاء شعار "DEBUG" في الزاوية
      debugShowCheckedModeBanner: false,
      // theme: الثيم (الألوان، الخطوط، التصميم العام)
      theme: ThemeData(
        // colorScheme: نظام الألوان - منSeed ينشئ ألوان متناسقة من لون أساسي
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        // useMaterial3: استخدام Material Design 3 (أحدث إصدار)
        useMaterial3: true,
      ),
      // home: الصفحة الأولى التي تظهر عند فتح التطبيق
      home: const BooksListPage(),
    );
  }
}
