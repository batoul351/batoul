import 'package:get/get.dart';
import '../Model/meal_model.dart';
import '../Service/meal_service.dart';
import 'package:flutter/material.dart';
class MealController extends GetxController {
  final MealService service = MealService();

  var meals = <MealModel>[].obs;
  var isLoading = false.obs;
  var selectedMeal = Rxn<MealModel>();

  void fetchMealsByCategory(int categoryId) async {
    isLoading.value = true;

    final response = await service.fetchMealsByCategory(categoryId);

    if (response == null) {
      Get.snackbar("خطأ", "فشل الاتصال بالسيرفر", backgroundColor: Colors.red);
    } else if (response.statusCode == 200) {
      final data = response.data;
      meals.value = List<MealModel>.from(data.map((e) => MealModel.fromJson(e)));
    } else {
      Get.snackbar("خطأ", "فشل في جلب الوجبات", backgroundColor: Colors.red);
    }

    isLoading.value = false;
  }

  Future<void> getMealDetails(int mealId) async {
    final response = await service.getMealDetails(mealId);

    if (response != null && response.statusCode == 200) {
      selectedMeal.value = MealModel.fromJson(response.data['message']);
    } else {
      Get.snackbar("خطأ", "فشل في جلب تفاصيل الوجبة", backgroundColor: Colors.red);
    }
  }

  Future<void> submitRating(int mealId, String ratingText) async {
    int? rating = int.tryParse(ratingText);
    if (rating == null || rating < 1 || rating > 5) {
      Get.snackbar("خطأ", "يجب أن يكون التقييم بين 1 و 5", backgroundColor: Colors.red);
      return;
    }

    final response = await service.submitRating(mealId, rating);

    if (response != null && response.statusCode == 200) {
      Get.snackbar("معلومات", response.data['message'], backgroundColor: Colors.green);
    } else {
      Get.snackbar("خطأ", "حدث خطأ أثناء إرسال التقييم", backgroundColor: Colors.red);
    }
  }
}
