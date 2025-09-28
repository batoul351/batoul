class VerificationResponseModel {
  final bool success;
  final String message;

  VerificationResponseModel({required this.success, required this.message});

  factory VerificationResponseModel.fromJson(Map<String, dynamic> json) {
    return VerificationResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
