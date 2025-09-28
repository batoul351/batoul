import 'package:get/get.dart';
import '../Model/category_model.dart';
import '../Service/category_service.dart';
import 'package:flutter/material.dart';

class CategoryController extends GetxController {
  final CategoryService service = CategoryService();

  var categories = <CategoryModel>[].obs;
  var isLoading = false.obs;

  void fetchCategories() async {
    isLoading.value = true;

    final response = await service.fetchCategories();

    if (response == null) {
      Get.snackbar("خطأ", "فشل الاتصال بالسيرفر", backgroundColor: Colors.red);
      isLoading.value = false;
      return;
    }
if (response.statusCode == 200) {
  final data = response.data;

  if (data is List && data.isNotEmpty) {
    categories.value = data.map((e) => CategoryModel.fromJson(e)).toList();
  } else {
    Get.snackbar("خطأ", "لا توجد بيانات متاحة", backgroundColor: Colors.red);
  }
} else if (response.statusCode == 401) {
  Get.snackbar("خطأ", "يرجى تسجيل الدخول أولاً", backgroundColor: Colors.orange);
} else {
  Get.snackbar("خطأ", "فشل تحميل الفئات: ${response.statusCode}", backgroundColor: Colors.red);
}

isLoading.value = false;
  }}