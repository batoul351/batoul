import 'package:get/get.dart';
import '../Service/favorite_service.dart';
import '../Model/favorite_model.dart';
import 'package:flutter/material.dart';

class FavoriteController extends GetxController {
  final FavoriteService service = FavoriteService();
  var favoriteItems = <FavoriteModel>[].obs;

  Future<void> addToFavorite(int mealId) async {
    final response = await service.addToFavorite(mealId);

    if (response != null && response.statusCode == 200) {
      Get.snackbar("المفضلة", response.data['message'] ?? "تمت الإضافة",
          backgroundColor: const Color(0xFFE2B09E),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar("خطأ", " لم يتم إضافة الوجبة",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> fetchFavorites() async {
    final response = await service.fetchFavorites();

    if (response != null && response.statusCode == 200) {
      final list = response.data['message'];
      favoriteItems.value = List<FavoriteModel>.from(list.map((e) => FavoriteModel.fromJson(e)));
    } else {
      Get.snackbar("خطأ", " فشل في جلب المفضلة",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> deleteFavorite(int mealId) async {
    final response = await service.deleteFavorite(mealId);

    if (response != null && response.statusCode == 200) {
      Get.snackbar("تم الحذف", response.data['message'] ?? "تم إزالة الوجبة من المفضلة",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      fetchFavorites();
    } else {
      Get.snackbar("خطأ", " فشل في حذف الوجبة",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
