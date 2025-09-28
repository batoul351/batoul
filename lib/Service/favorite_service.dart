import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class FavoriteService {
  static const String baseUrl = "http://192.168.1.105:8000/api";
  final Dio dio;
  final box = GetStorage();

  FavoriteService()
      : dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          headers: {
            'Authorization': 'Bearer ${GetStorage().read('access_token')}',
            'Accept': 'application/json',
          },
        ));

  Future<Response?> addToFavorite(int mealId) async {
    try {
      return await dio.get('/favorite/$mealId');
    } catch (_) {
      return null;
    }
  }

  Future<Response?> fetchFavorites() async {
    try {
      return await dio.get('/getFavorite');
    } catch (_) {
      return null;
    }
  }

  Future<Response?> deleteFavorite(int mealId) async {
    try {
      return await dio.get('/deletefavorite/$mealId');
    } catch (_) {
      return null;
    }
  }
}
