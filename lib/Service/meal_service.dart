import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class MealService {
  static const String baseUrl = "http://192.168.1.102:8000/api";
  final Dio dio = Dio();
  final box = GetStorage();

  String? getToken() => box.read("access_token");

  Future<Response?> fetchMealsByCategory(int categoryId) async {
    final token = getToken();
    if (token == null || token.isEmpty) return null;

    try {
      return await dio.get(
        "$baseUrl/getfoodd/$categoryId",
        options: Options(headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        }),
      );
    } catch (_) {
      return null;
    }
  }

  Future<Response?> getMealDetails(int mealId) async {
    final token = getToken();
    if (token == null || token.isEmpty) return null;

    try {
      return await dio.get(
        "$baseUrl/describe/$mealId",
        options: Options(headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        }),
      );
    } catch (_) {
      return null;
    }
  }

  Future<Response?> submitRating(int mealId, int rating) async {
    final token = getToken();
    if (token == null || token.isEmpty) return null;

    try {
      return await dio.post(
        "$baseUrl/Rating/$mealId",
        data: {"rating": rating},
        options: Options(headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        }),
      );
    } catch (_) {
      return null;
    }
  }
}
