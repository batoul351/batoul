class ResetModel {
  final String code;
  final String newPassword;

  ResetModel({required this.code, required this.newPassword});

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'new_password': newPassword,
    };
  }
}
