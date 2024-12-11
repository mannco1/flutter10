class User{
  int userId;
  String username;
  String email;
  String password;
  String image;
  String phone;

  User({
    required this.userId,
    required this.username,
    required this.email,
    required this.password,
    required this.image,
    required this.phone
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        userId: json['user_id'].toInt() ?? 0,
        username: json['username'] ?? '',
        image: json['image'] ?? '',
        email: json['email'] ?? '',
        password: json['password_hash'] ?? '',
        phone: json['phone'] ?? ''
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'image': image,
      'email': email,
      'password_hash': password,
      'phone': phone
    };
  }
}