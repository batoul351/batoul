import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class ResetService {
  static const String baseUrl = "http://192.168.1.102:8000/api";
  final Dio dio = Dio();
  final box = GetStorage();

  Future<Response?> sendCode() async {
    final token = box.read("access_token");
    if (token == null || token.isEmpty) {
      print("No token found");
      return null;
    }

    try {
      final response = await dio.get(
        "$baseUrl/ForgetPassword",
        options: Options(headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        }),
      );
      print("SendCode response: ${response.statusCode} - ${response.data}");
      return response;
    } catch (e) {
      print("Error in sendCode: $e");
      return null;
    }
  }

  Future<Response?> changePassword(String code, String newPassword) async {
    final token = box.read("access_token");
    if (token == null || token.isEmpty) {
      print("No token found");
      return null;
    }

    try {
      final response = await dio.post(
        "$baseUrl/ChangePassword",
        data: {
          "code": code,
          "new_password": newPassword,
        },
        options: Options(headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        }),
      );
      print("ChangePassword response: ${response.statusCode} - ${response.data}");
      return response;
    } catch (e) {
      print("Error in changePassword: $e");
      return null;
    }
  }
}
