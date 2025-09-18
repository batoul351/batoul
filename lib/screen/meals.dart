import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api_service/api_Meals.dart';
import 'meal_details_screen.dart';
import 'favorites_screen.dart';
import '../api_service/api_favorite.dart';

class MealsPage extends StatelessWidget {
  final int categoryId;
  final String categoryName;

  final MealController mealController = Get.put(MealController());
  final FavoriteController favoriteController = Get.put(FavoriteController());

  MealsPage({required this.categoryId, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    mealController.fetchMealsByCategory(categoryId);

    return Scaffold(
      appBar: AppBar(
        title: Text("Meals - $categoryName", style: const TextStyle(fontSize: 24, color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 226, 176, 158),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.white),
            onPressed: () => Get.to(() => FavoritesScreen()),
          ),
        ],
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

        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.55, // ✅ زيادة ارتفاع البطاقة
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: mealController.meals.length,
          itemBuilder: (context, index) {
            final meal = mealController.meals[index];

            return GestureDetector(
              onTap: () => Get.to(() => MealDetailsScreen(meal: meal)),
              child: Card(
                color: const Color.fromARGB(255, 226, 176, 158),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.asset(
                        'assets/food.png', // ✅ صورة محلية ثابتة
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Text(meal['name'], style: const TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text("${meal['price']} SYP", style: const TextStyle(fontSize: 16, color: Colors.white70)),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.shopping_cart, color: Colors.white),
                            onPressed: () {
                              // تنفيذ إضافة للسلة هنا
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.favorite_border, color: Colors.white),
                            onPressed: () {
                              favoriteController.addToFavorite(meal['id']);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
