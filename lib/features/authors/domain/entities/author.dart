class Author {
  final int? id;
  final String name;
  final String hometown;
  final DateTime birthdate;
  final String? profileImagePath;

  Author({
    this.id,
    required this.name,
    required this.hometown,
    required this.birthdate,
    this.profileImagePath,
  });
}

