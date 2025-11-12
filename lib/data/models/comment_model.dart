import 'package:library_books/domain/entities/comment.dart';

class CommentModel extends Comment {
  CommentModel({
    int? id,
    required int bookId,
    required String writerName,
    required String content,
    required DateTime dateTime,
    int likes = 0,
    int dislikes = 0,
  }) : super(
          id: id,
          bookId: bookId,
          writerName: writerName,
          content: content,
          dateTime: dateTime,
          likes: likes,
          dislikes: dislikes,
        );

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
