class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final bool isDeleted;
  final bool isBlocked;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.isDeleted = false,
    this.isBlocked = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'customer',
      isDeleted: json['isDeleted'] ?? false,
      isBlocked: json['isBlocked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'role': role,
      'isDeleted': isDeleted,
      'isBlocked': isBlocked,
    };
  }
}