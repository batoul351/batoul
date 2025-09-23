import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

class MealController extends GetxController {
  static const String baseUrl = "http://192.168.1.102:8000/api";
  final Dio dio = Dio();
  final box = GetStorage();

  var meals = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var selectedMeal = Rxn<Map<String, dynamic>>();

  String? getToken() {
    return box.read("access_token");
  }

  void fetchMealsByCategory(int categoryId) async {
    isLoading.value = true;

    try {
      final token = getToken();
      if (token == null || token.isEmpty) {
        Get.snackbar("خطأ", "يرجى تسجيل الدخول أولاً", backgroundColor: Colors.red);
        isLoading.value = false;
        return;
      }

      final response = await dio.get(
        "$baseUrl/getfoodd/$categoryId",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        final decoded = response.data;
        meals.value = List<Map<String, dynamic>>.from(
          decoded.map((meal) {
            meal['image'] = "http://192.168.1.102:8000/" + meal['image'].replaceAll("\\", "");
            return meal;
          }),
        );
      } else {
        Get.snackbar("خطأ", "فشل في جلب الوجبات", backgroundColor: Colors.red);
      }
    } catch (e) {
      Get.snackbar("خطأ", "خطأ في الاتصال بالسيرفر: $e", backgroundColor: Colors.red);
    }

    isLoading.value = false;
  }

  Future<void> getMealDetails(int mealId) async {
    final token = getToken();
    if (token == null || token.isEmpty) return;

    try {
      final response = await dio.get(
        "$baseUrl/describe/$mealId",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        selectedMeal.value = Map<String, dynamic>.from(data['message']);
      } else {
        Get.snackbar("خطأ", "فشل في جلب تفاصيل الوجبة", backgroundColor: Colors.red);
      }
    } catch (e) {
      Get.snackbar("خطأ", "خطأ في الاتصال بالسيرفر: $e", backgroundColor: Colors.red);
    }
  }

  Future<void> submitRating(int mealId, String ratingText) async {
    final token = getToken();
    if (token == null || token.isEmpty) {
      Get.snackbar("خطأ", "يرجى تسجيل الدخول أولاً!", backgroundColor: Colors.red);
      return;
    }

    int? rating = int.tryParse(ratingText);
    if (rating == null || rating < 1 || rating > 5) {
      Get.snackbar("خطأ", "يجب أن يكون التقييم بين 1 و 5", backgroundColor: Colors.red);
      return;
    }

    try {
      final response = await dio.post(
        "$baseUrl/Rating/$mealId",
        data: {"rating": rating},
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
        ),
      );

      final result = response.data;
      Get.snackbar("معلومات", result['message'], backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء إرسال التقييم: $e", backgroundColor: Colors.red);
    }
  }
}
