import 'package:dio/dio.dart';

class LoginService {
  static const String baseUrl = "http://192.168.1.102:8000/api";
  static const String endpoint = "/login";

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final String url = baseUrl + endpoint;

    try {
      final response = await Dio().post(
        url,
        data: {
          "email": email,
          "password": password,
        },
        options: Options(headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        }),
      );

      if (response.statusCode == 201 && response.data.containsKey("token")) {
        return {
          "success": true,
          "token": response.data["token"],
          "message": "تم تسجيل الدخول بنجاح!",
        };
      } else if (response.statusCode == 401) {
        return {
          "success": false,
          "message": "البريد الإلكتروني أو كلمة المرور غير صحيحة.",
        };
      } else {
        return {
          "success": false,
          "message": response.data['message'] ?? "خطأ غير متوقع.",
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "حدث خطأ أثناء الاتصال بالسيرفر: $e",
      };
    }
  }
}
