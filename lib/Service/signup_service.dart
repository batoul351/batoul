import 'package:dio/dio.dart';

class SignUpService {
  static const String baseUrl = "http://192.168.1.105:8000/api";

  static Future<Map<String, dynamic>> registerUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    const String endpoint = "/signup";
    final String url = baseUrl + endpoint;

    try {
      final response = await Dio().post(
        url,
        data: {
          "first_name": firstName,
          "last_name": lastName,
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
        };
      } else {
        return {
          "success": false,
          "message": response.data['message'],
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "حدث خطأ: $e",
      };
    }
  }
}
