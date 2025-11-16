import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_books/features/books/data/models/book_models.dart';
import 'package:library_books/features/books/presentation/cubit/book_cubit.dart';

class AddEditBookPage extends StatefulWidget {
  final BookModel? book;

  const AddEditBookPage({super.key, this.book});

  @override
  State<AddEditBookPage> createState() => _AddEditBookPageState();
}

class _AddEditBookPageState extends State<AddEditBookPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ratingController = TextEditingController();
  final _publishingHouseIdController = TextEditingController();
  final _coverImagePathController = TextEditingController();
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    if (widget.book != null) {
      _titleController.text = widget.book!.title;
      _descriptionController.text = widget.book!.shortDescription;
      _ratingController.text = widget.book!.rating.toString();
      _publishingHouseIdController.text =
          widget.book!.publishingHouseId.toString();
      _coverImagePathController.text = widget.book!.coverImagePath ?? '';
      _isFavorite = widget.book!.isFavorite;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _ratingController.dispose();
    _publishingHouseIdController.dispose();
    _coverImagePathController.dispose();
    super.dispose();
  }

  void _saveBook(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final book = BookModel(
        id: widget.book?.id,
        title: _titleController.text.trim(),
        shortDescription: _descriptionController.text.trim(),
        rating: double.parse(_ratingController.text),
        publishingHouseId: int.parse(_publishingHouseIdController.text),
        isFavorite: _isFavorite,
        coverImagePath: _coverImagePathController.text.trim().isEmpty
            ? null
            : _coverImagePathController.text.trim(),
      );

      final bookCubit = BlocProvider.of<BookCubit>(context);
      if (widget.book == null) {
        bookCubit.addBook(book);
      } else {
        bookCubit.updateBook(book);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book == null ? 'إضافة كتاب جديد' : 'تعديل كتاب'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // عنوان الكتاب
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'عنوان الكتاب *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'يرجى إدخال عنوان الكتاب';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // وصف الكتاب
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'وصف الكتاب *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
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
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'يرجى إدخال التقييم';
                  }
                  final rating = double.tryParse(value);
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
                  if (int.tryParse(value) == null) {
                    return 'يرجى إدخال رقم صحيح';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // رابط صورة الغلاف
              Image.network(
                width: 20,
                height: 150,
                _coverImagePathController.text.isNotEmpty
                    ? _coverImagePathController.text
                    : 'https://via.placeholder.com/150',
              ),
              const SizedBox(height: 16),
              // المفضلة
              CheckboxListTile(
                title: const Text('إضافة إلى المفضلة'),
                value: _isFavorite,
                onChanged: (value) {
                  setState(() {
                    _isFavorite = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 24),
              // زر الحفظ
              ElevatedButton(
                onPressed: () => _saveBook(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
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
