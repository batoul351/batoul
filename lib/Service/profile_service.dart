import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class ProfileService {
  static const String baseUrl = "http://192.168.1.102:8000/api";
  final Dio dioClient = Dio();
  final box = GetStorage();

  String? getToken() => box.read("access_token");

  Future<Response?> submitProfile(FormData formData) async {
    final token = getToken();
    if (token == null || token.isEmpty) return null;

    try {
      return await dioClient.post(
        "$baseUrl/profile",
        data: formData,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        }),
      );
    } catch (_) {
      return null;
    }
  }

  Future<Response?> fetchProfile() async {
    final token = getToken();
    if (token == null || token.isEmpty) return null;

    try {
      return await dioClient.get(
        "$baseUrl/getProfile",
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
    } catch (_) {
      return null;
    }
  }
}
