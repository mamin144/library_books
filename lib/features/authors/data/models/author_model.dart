import 'package:library_books/features/authors/domain/entities/author.dart';

class AuthorModel extends Author {
  AuthorModel({
    super.id,
    required super.name,
    required super.hometown,
    required super.birthdate,
    super.profileImagePath,
  });

  factory AuthorModel.fromMap(Map<String, dynamic> map) {
    return AuthorModel(
      id: map['id'],
      name: map['name'],
      hometown: map['hometown'],
      birthdate: DateTime.parse(map['birthdate']),
      profileImagePath: map['profileImagePath'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'hometown': hometown,
      'birthdate': birthdate.toIso8601String(),
      'profileImagePath': profileImagePath,
    };
  }
}

