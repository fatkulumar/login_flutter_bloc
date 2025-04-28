class UserModel {
  final int? id;
  final String name;
  final String email;
  final DateTime? emailVerifiedAt;
  final String password;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    required this.password,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] != null ? json['id'] as int : null,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      emailVerifiedAt:
          json['email_verified_at'] != null
              ? DateTime.parse(json['email_verified_at'])
              : null,
      password: json['password'] ?? '',
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : DateTime.now(),
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : DateTime.now(),
    );
  }

  // Override toString() untuk mendapatkan representasi yang lebih jelas
  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, emailVerifiedAt: $emailVerifiedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}