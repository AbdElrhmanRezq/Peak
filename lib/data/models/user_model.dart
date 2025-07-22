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
  final String? profilePictureUrl;

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
    this.profilePictureUrl,
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
      profilePictureUrl: json['profile_picture_url'],
    );
  }

  UserModel copyWith({
    String? email,
    String? username,
    String? gender,
    int? streak,
    int? exp,
    DateTime? createdAt,
    int? weight,
    int? height,
    int? age,
  }) {
    return UserModel(
      id: id, // ID is required and unchanged
      email: email ?? this.email,
      username: username ?? this.username,
      gender: gender ?? this.gender,
      streak: streak ?? this.streak,
      exp: exp ?? this.exp,
      createdAt: createdAt ?? this.createdAt,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      age: age ?? this.age,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'gender': gender,
      'streak': streak,
      'exp': exp,
      'created_at': createdAt?.toIso8601String(),
      'weight': weight,
      'height': height,
      'age': age,
      'profile_picture_url': profilePictureUrl,
    };
  }
}
