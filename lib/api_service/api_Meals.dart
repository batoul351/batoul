import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class MealController extends GetxController {
  static const String baseUrl = "http://192.168.1.102:8000/api";

  var meals = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var selectedMeal = Rxn<Map<String, dynamic>>();

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  void fetchMealsByCategory(int categoryId) async {
    isLoading.value = true;
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) {
        Get.snackbar("Error", "Please log in first", backgroundColor: Colors.red);
        isLoading.value = false;
        return;
      }

      final response = await http.get(
        Uri.parse("$baseUrl/getfoodd/$categoryId"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        meals.value = List<Map<String, dynamic>>.from(
          decoded.map((meal) {
            meal['image'] = "http://192.168.1.102:8000/" + meal['image'].replaceAll("\\", "");
            return meal;
          }),
        );
      } else {
        Get.snackbar("Error", "Failed to fetch meals", backgroundColor: Colors.red);
      }
    } catch (e) {
      Get.snackbar("Error", "Connection issue: $e", backgroundColor: Colors.red);
    }
    isLoading.value = false;
  }

  Future<void> getMealDetails(int mealId) async {
    final token = await getToken();
    if (token == null) return;

    try {
      final res = await http.get(
        Uri.parse("$baseUrl/describe/$mealId"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        selectedMeal.value = Map<String, dynamic>.from(data['message']);
      } else {
        Get.snackbar("خطأ", "فشل في جلب تفاصيل الوجبة");
      }
    } catch (e) {
      Get.snackbar("خطأ", "خطأ في الاتصال بالسيرفر: $e");
    }
  }

  Future<void> submitRating(int mealId, String ratingText) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      Get.snackbar("خطأ", "يرجى تسجيل الدخول أولاً!", backgroundColor: Colors.red);
      return;
    }

    int? rating = int.tryParse(ratingText);
    if (rating == null || rating < 1 || rating > 5) {
      Get.snackbar("خطأ", "يجب أن يكون التقييم بين 1 و 5", backgroundColor: Colors.red);
      return;
    }

    final String apiUrl = "$baseUrl/Rating/$mealId";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"rating": rating}),
      );

      final result = jsonDecode(response.body);
      Get.snackbar("معلومات", result['message'], backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء إرسال التقييم: $e", backgroundColor: Colors.red);
    }
  }
}
