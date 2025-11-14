import 'package:library_books/domain/entities/comment.dart';

class CommentModel extends Comment {
  CommentModel({
    required super.id,
    required super.bookId,
    required super.writerName,
    required super.content,
    required super.dateTime,
    super.likes = 0,
    super.dislikes = 0,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'],
      bookId: map['bookId'],
      writerName: map['writerName'],
      content: map['content'],
      dateTime: DateTime.parse(map['dateTime']),
      likes: map['likes'],
      dislikes: map['dislikes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookId': bookId,
      'writerName': writerName,
      'content': content,
      'dateTime': dateTime.toIso8601String(),
      'likes': likes,
      'dislikes': dislikes,
    };
  }
}
