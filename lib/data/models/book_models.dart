import 'package:library_books/domain/entities/book.dart';

class BookModel extends Book {
  BookModel({
    int? id,
    required String title,
    required String shortDescription,
    required double rating,
    required int publishingHouseId,
    bool isFavorite = false,
    String? coverImagePath,
  }) : super(
          id: id,
          title: title,
          shortDescription: shortDescription,
          rating: rating,
          publishingHouseId: publishingHouseId,
          isFavorite: isFavorite,
          coverImagePath: coverImagePath,
        );

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
