class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String workType;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.workType,
  });

  String get fullName => '$firstName $lastName';
}
