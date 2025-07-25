class UserModel {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final String address;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        avatar: json['avatar'],
        address: json['address'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'avatar': avatar,
        'address': address,
      };
} 