class UserModel {
  final String id;
  final String email;
  final String name;
  final String? gender;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.gender,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'gender': gender,
  };
}
