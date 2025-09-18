import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class FavoriteController extends GetxController {
  static const String baseUrl = "http://192.168.1.103:8000/api";

  var favorites = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  /// جلب التوكن من التخزين المحلي
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  /// إضافة وجبة إلى المفضلة باستخدام GET (حسب Laravel)
  Future<void> addToFavorite(int mealId) async {
    final token = await getToken();
    if (token == null) {
      Get.snackbar(
        "خطأ",
        "يرجى تسجيل الدخول أولاً",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/favorite/$mealId"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Get.snackbar(
          "تم",
          data['message'] ?? "تمت الإضافة بنجاح",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        fetchFavoritesFromLaravel(); // تحديث القائمة
      } else {
        Get.snackbar(
          "تنبيه",
          data['message'] ?? "فشل في الإضافة",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "خطأ",
        "حدث خطأ أثناء الاتصال بالسيرفر",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
Future<void> deleteFavorite(int mealId) async {
  final token = await getToken(); // تأكد أن لديك دالة getToken
  if (token == null || token.isEmpty) {
    Get.snackbar("خطأ", "يرجى تسجيل الدخول أولاً", backgroundColor: Colors.red);
    return;
  }

  try {
    final response = await http.get(
      Uri.parse("http://192.168.1.103:8000/api/deletefavorite/$mealId"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    final result = jsonDecode(response.body);
    Get.snackbar("معلومات", result['message'], backgroundColor: Colors.green);

    // تحديث القائمة بعد الحذف
    fetchFavoritesFromLaravel();
  } catch (e) {
    Get.snackbar("خطأ", "فشل في حذف الوجبة: $e", backgroundColor: Colors.red);
  }
}

Future<void> fetchFavoritesFromLaravel() async {
  isLoading.value = true;

  final token = await getToken();
  if (token == null) {
    isLoading.value = false;
    return;
  }

  try {
    final response = await http.get(
      Uri.parse("$baseUrl/getFavorite"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> rawList = data['message'];

      favorites.value = rawList.map<Map<String, dynamic>>((item) {
        return {
          'id': item['food_id'],
          'name': "وجبة رقم ${item['food_id']}",
          'price': "غير متوفر",
          'image': "https://via.placeholder.com/150", // صورة افتراضية
        };
      }).toList();
    }
  } catch (e) {
    Get.snackbar(
      "خطأ",
      "تعذر تحميل المفضلة",
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  isLoading.value = false;
}

}
