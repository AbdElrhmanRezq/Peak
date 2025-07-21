class UserModel {
  final String id;
  final String? email;
  final String? username;
  final String? gender;
  final int streak;
  final int exp;
  final DateTime? createdAt;
  final int? weight;
  final int? height;
  final int? age;

  UserModel({
    required this.id,
    this.email,
    this.username,
    this.gender,
    this.streak = 0,
    this.exp = 0,
    this.createdAt,
    this.weight,
    this.height,
    this.age,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      gender: json['gender'],
      streak: json['streak'] ?? 0,
      exp: json['exp'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      weight: json['weight'],
      height: json['height'],
      age: json['age'],
    );
  }
}
