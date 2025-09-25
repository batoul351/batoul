import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

class CategoryController extends GetxController {
  static const String baseUrl = "http://192.168.1.105:8000/api";
  final Dio dio = Dio();
  final box = GetStorage();

  var categories = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  void fetchCategories() async {
    isLoading.value = true;

    try {
      final token = box.read("access_token");
      if (token == null || token.isEmpty) {
        Get.snackbar("خطأ", "يرجى تسجيل الدخول أولاً للحصول على البيانات", backgroundColor: Colors.orange);
        isLoading.value = false;
        return;
      }

      final response = await dio.get(
        "$baseUrl/getParts",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200) {
        final decodedData = response.data;

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
