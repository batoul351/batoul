import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api_service/api_Meals.dart';
import 'meal_details_screen.dart';

class MealsPage extends StatelessWidget {
  final int categoryId;
  final String categoryName;
  final MealController mealController = Get.put(MealController());

  MealsPage({required this.categoryId, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    mealController.fetchMealsByCategory(categoryId);

    return Scaffold(
      appBar: AppBar(
        title: Text("Meals - $categoryName", style: const TextStyle(fontSize: 24, color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 226, 176, 158),
      ),
      body: Obx(() {
        if (mealController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (mealController.meals.isEmpty) {
          return const Center(
            child: Text("⚠ No meals available", style: TextStyle(fontSize: 20, color: Colors.red)),
          );
        }

        return ListView.builder(
          itemCount: mealController.meals.length,
          itemBuilder: (context, index) {
            final meal = mealController.meals[index];

            return Card(
              color: const Color.fromARGB(255, 226, 176, 158),
              margin: const EdgeInsets.all(8),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    meal['image'],
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 50, color: Colors.red),
                  ),
                ),
                title: Text(meal['name'], style: const TextStyle(fontSize: 20, color: Colors.white)),
                subtitle: Text("${meal['price']} SYP", style: const TextStyle(fontSize: 18, color: Colors.white70)),
                onTap: () => Get.to(() => MealDetailsScreen(meal: meal)),
              ),
            );
          },
        );
      }),
    );
  }
}
