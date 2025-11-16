class Book {
  final int? id;
  final String title;
  final String shortDescription;
  final double rating; // 0.0 - 5.0
  final int publishingHouseId;
  final bool isFavorite;
  final String? coverImagePath;

  Book({
    this.id,
    required this.title,
    required this.shortDescription,
    required this.rating,
    required this.publishingHouseId,
    this.isFavorite = false,
    this.coverImagePath,
  });
}

