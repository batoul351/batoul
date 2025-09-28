import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class CategoryService {
  static const String baseUrl = "http://192.168.1.105:8000/api";
  static const String endpoint = "/getParts";
  final Dio dio = Dio();
  final box = GetStorage();

  Future<Response?> fetchCategories() async {
    final token = box.read("access_token");
    if (token == null || token.isEmpty) return null;

    try {
      final response = await dio.get(
        baseUrl + endpoint,
        options: Options(headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        }),
      );
      return response;
    } catch (e) {
      return null;
    }
  }
}
