import 'package:library_books/features/books/domain/entities/book.dart';

class BookModel extends Book {
  BookModel({
    super.id,
    required super.title,
    required super.shortDescription,
    required super.rating,
    required super.publishingHouseId,
    super.isFavorite = false,
    super.coverImagePath,
  });

  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      id: map['id'],
      title: map['title'],
      shortDescription: map['shortDescription'],
      rating: map['rating'],
      publishingHouseId: map['publishingHouseId'],
      isFavorite: map['isFavorite'] == 1,
      coverImagePath: map['coverImagePath'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'shortDescription': shortDescription,
      'rating': rating,
      'publishingHouseId': publishingHouseId,
      'isFavorite': isFavorite ? 1 : 0,
      'coverImagePath': coverImagePath,
    };
  }
}

