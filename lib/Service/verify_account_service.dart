import 'package:dio/dio.dart';
import '../Model/verification_response_model.dart';

class VerifyAccountService {
  static const String baseUrl = "http://192.168.1.102:8000/api";
  static const String endpoint = "/verification_signup";

  static Future<VerificationResponseModel> verifyAccount({
    required String email,
    required String code,
  }) async {
    final String url = baseUrl + endpoint;

    try {
      final response = await Dio().post(
        url,
        data: {
          "email": email,
          "code": code,
        },
        options: Options(headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        }),
      );

      if (response.statusCode == 200) {
        return VerificationResponseModel.fromJson({
          "success": true,
          "message": response.data["message"] ?? "تم التحقق بنجاح.",
        });
      } else {
        return VerificationResponseModel.fromJson({
          "success": false,
          "message": response.data["message"] ?? "فشل التحقق.",
        });
      }
    } catch (e) {
      return VerificationResponseModel(
        success: false,
        message: "خطأ في الاتصال بالسيرفر: $e",
      );
    }
  }
}
