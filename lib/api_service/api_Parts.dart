import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class CategoryController extends GetxController {
  static const String baseUrl = "http://192.168.1.102:8000/api";

  var categories = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  void fetchCategories() async {
    isLoading.value = true;
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) {
        Get.snackbar("خطأ", "يرجى تسجيل الدخول أولاً للحصول على البيانات", backgroundColor: Colors.orange);
        isLoading.value = false;
        return;
      }

      final response = await http.get(
        Uri.parse("$baseUrl/getParts"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);

        if (decodedData is List && decodedData.isNotEmpty) {
          categories.value = List<Map<String, dynamic>>.from(decodedData);
        } else {
          Get.snackbar("خطأ", "لا توجد بيانات متاحة", backgroundColor: Colors.red);
        }
      } else if (response.statusCode == 401) {
        Get.snackbar("خطأ", "المصادقة مطلوبة، قم بتسجيل الدخول أولاً", backgroundColor: Colors.orange);
      } else {
        Get.snackbar("خطأ", "فشل تحميل الفئات: ${response.statusCode}", backgroundColor: Colors.red);
      }
    } catch (e) {
      Get.snackbar("خطأ", "خطأ في الاتصال بالسيرفر: $e", backgroundColor: Colors.red);
    }
    isLoading.value = false;
  }
}
