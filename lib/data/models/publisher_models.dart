import 'package:library_books/domain/entities/publisher.dart';

class PublisherModel extends Publisher {
  PublisherModel({
    int? id,
    required String title,
    required String address,
    required String phone,
  }) : super(
          id: id,
          title: title,
          address: address,
          phone: phone,
        );

  /// convert from map (SQLite → Model)
  factory PublisherModel.fromMap(Map<String, dynamic> map) {
    return PublisherModel(
      id: map['id'],
      title: map['title'],
      address: map['address'],
      phone: map['phone'],
    );
  }

  /// convert to map (Model → SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'address': address,
      'phone': phone,
    };
  }
}
