import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

class FavoriteController extends GetxController {
  final GetStorage box = GetStorage();
  late Dio dio;

  RxList<Map<String, dynamic>> favoriteItems = <Map<String, dynamic>>[].obs;

  static const String baseUrl = "http://192.168.1.105:8000/api";

  @override
  void onInit() {
    super.onInit();
    final token = box.read('access_token');
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    ));
  }

  Future<void> addToFavorite(int mealId) async {
    try {
      final response = await dio.get('/favorite/$mealId');
      Get.snackbar("المفضلة", response.data['message'] ?? "تمت الإضافة",
          backgroundColor: const Color(0xFFE2B09E),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("خطأ", "⚠️ لم يتم إضافة الوجبة",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> fetchFavorites() async {
    try {
      final response = await dio.get('/getFavorite');
      favoriteItems.value = List<Map<String, dynamic>>.from(response.data['message']);
    } catch (e) {
      Get.snackbar("خطأ", "⚠️ فشل في جلب المفضلة",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
  }
  Future<void> deleteFavorite(int mealId) async {
  try {
    final response = await dio.get('/deletefavorite/$mealId');
    Get.snackbar("Deleted", response.data['message'] ?? "Meal removed from favorites",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM);

    // تحديث القائمة بعد الحذف
    fetchFavorites();
  } catch (e) {
    Get.snackbar("Error", "⚠️ Failed to delete meal",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM);
  }
}

}
