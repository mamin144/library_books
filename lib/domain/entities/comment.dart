class Comment {
  final int? id;
  final int bookId;
  final String writerName;
  final String content;
  final DateTime dateTime;
  final int likes;
  final int dislikes;

  Comment({
    this.id,
    required this.bookId,
    required this.writerName,
    required this.content,
    required this.dateTime,
    this.likes = 0,
    this.dislikes = 0,
  });
}
