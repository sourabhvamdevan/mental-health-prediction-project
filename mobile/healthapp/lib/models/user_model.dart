class UserModel {
  final String? userId;
  final String? userName;
  final String? email;
  final String? phone;
  final String? message;
  final bool success;

  UserModel({
    this.userId,
    this.userName,
    this.email,
    this.phone,
    this.message,
    required this.success,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      userName: json['userName'],
      email: json['email'],
      phone: json['phone'],
      message: json['message'],
      success: json['success'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'email': email,
      'phone': phone,
      'message': message,
      'success': success,
    };
  }
}
