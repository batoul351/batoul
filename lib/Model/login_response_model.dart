class LoginResponseModel {
  final String token;
  final String message;

  LoginResponseModel({required this.token, required this.message});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json['token'] ?? '',
      message: json['message'] ?? '',
    );
  }
}
