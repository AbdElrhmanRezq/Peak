class UserModel {
  final String id;
  final String email;
  final String? username;
  final String? gender;
  final int streak;
  final DateTime? createdAt;
  final int? weight;
  final int? height;
  final int? age;
  final String? profilePictureUrl;
  final String? phoneNumber;
  final String? name;

  UserModel({
    required this.id,
    required this.email,
    this.username,
    this.gender,
    this.streak = 0,
    this.createdAt,
    this.weight,
    this.height,
    this.age,
    this.profilePictureUrl,
    this.phoneNumber,
    this.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      gender: json['gender'],
      streak: json['streak'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      weight: json['weight'],
      height: json['height'],
      age: json['age'],
      profilePictureUrl: json['profile_picture_url'],
      phoneNumber: json['phone_number'],
      name: json['name'],
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
    String? phoneNumber,
    String? name,
  }) {
    return UserModel(
      id: id, // ID is required and unchanged
      email: email ?? this.email,
      username: username ?? this.username,
      gender: gender ?? this.gender,
      streak: streak ?? this.streak,
      createdAt: createdAt ?? this.createdAt,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      age: age ?? this.age,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'gender': gender,
      'streak': streak,
      'created_at': createdAt?.toIso8601String(),
      'weight': weight,
      'height': height,
      'age': age,
      'profile_picture_url': profilePictureUrl,
      'phone_number': phoneNumber,
      'name': name,
    };
  }
}
