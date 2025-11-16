import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_books/features/books/data/models/book_models.dart';
import 'package:library_books/features/books/data/repositories/book_repositories.dart';
import 'package:library_books/features/books/presentation/cubit/book_cubit.dart';
import 'package:library_books/features/books/presentation/widgets/book_card.dart';
import 'package:library_books/features/books/presentation/pages/add_edit_book_page.dart';

class BooksListPage extends StatelessWidget {
  const BooksListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookCubit(BookRepository())..getAllBooks(),
      child: const BooksListView(),
    );
  }
}

class BooksListView extends StatefulWidget {
  const BooksListView({super.key});

  @override
  State<BooksListView> createState() => _BooksListViewState();
}

class _BooksListViewState extends State<BooksListView> {
  final TextEditingController _searchController = TextEditingController();
  bool _sortAscending = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مكتبة الكتب'),
        centerTitle: true,
        actions: [
          // زر الترتيب
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              context.read<BookCubit>().sortBooksByRating(
                    ascending: _sortAscending,
                  );
              setState(() {
                _sortAscending = !_sortAscending;
              });
            },
            tooltip: 'ترتيب حسب التقييم',
          ),
        ],
      ),
      body: Column(
        children: [
          // شريط البحث
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ابحث عن كتاب...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<BookCubit>().getAllBooks();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                context.read<BookCubit>().searchBooks(value);
              },
            ),
          ),
          // قائمة الكتب
          Expanded(
            child: BlocConsumer<BookCubit, BookState>(
              listener: (context, state) {
                if (state is BookError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (state is BookOperationSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is BookLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is BookLoaded) {
                  if (state.books.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.book_outlined,
                              size: 64, color: Colors.grey),
                          SizedBox(height: 16),
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
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<BookCubit>().getAllBooks();
                    },
                    child: ListView.builder(
                      itemCount: state.books.length,
                      itemBuilder: (context, index) {
                        final book = state.books[index];
                        return BookCard(
                          book: book,
                          onTap: () {
                            // يمكن فتح صفحة تفاصيل الكتاب
                          },
                          onEdit: () {
                            final bookCubit = context.read<BookCubit>();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: bookCubit,
                                  child: AddEditBookPage(book: book),
                                ),
                              ),
                            );
                          },
                          onDelete: () {
                            _showDeleteDialog(context, book);
                          },
                        );
                      },
                    ),
                  );
                } else if (state is BookError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<BookCubit>().getAllBooks();
                          },
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  );
                }
                return const Center(
                  child: Text('ابدأ بإضافة كتاب جديد'),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final bookCubit = context.read<BookCubit>();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: bookCubit,
                child: const AddEditBookPage(),
              ),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('إضافة كتاب'),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, BookModel book) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الكتاب'),
        content: Text('هل أنت متأكد من حذف "${book.title}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              context.read<BookCubit>().deleteBook(book.id!);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}
