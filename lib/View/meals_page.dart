import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/meal_controller.dart';
import '../Controller/favorite_controller.dart';
import '../Model/meal_model.dart';
import 'meal_details_page.dart';

class MealsPage extends StatelessWidget {
  final int categoryId;
  final String categoryName;

  final MealController mealController = Get.put(MealController());
  final FavoriteController favoriteController = Get.put(FavoriteController());

  MealsPage({required this.categoryId, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = theme.primaryColor;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final cardColor = theme.cardColor;
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.white;
    final subtitleColor = theme.textTheme.bodySmall?.color ?? Colors.white70;

    mealController.fetchMealsByCategory(categoryId);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: accentColor,
        title: Text(
          "Meals - $categoryName",
          style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (mealController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (mealController.meals.isEmpty) {
          return Center(
            child: Text(
              "لا توجد وجبات متاحة",
              style: theme.textTheme.titleMedium?.copyWith(color: Colors.red, fontSize: 20),
            ),
          );
        }

        return ListView.builder(
          itemCount: mealController.meals.length,
          itemBuilder: (context, index) {
            final meal = mealController.meals[index];

            return Card(
              color: cardColor,
              margin: const EdgeInsets.all(8),
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    meal.image,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.broken_image,
                      size: 50,
                      color: accentColor,
                    ),
                  ),
                ),
                title: Text(
                  meal.name,
                  style: theme.textTheme.titleMedium?.copyWith(fontSize: 20, color: textColor),
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${meal.price} SYP",
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 18, color: subtitleColor),
                    ),
                    IconButton(
                      icon: Icon(Icons.favorite_border, color: accentColor),
                      onPressed: () {
                        favoriteController.addToFavorite(meal.id);
                      },
                    ),
                  ],
                ),
                onTap: () => Get.to(() => MealDetailsScreen(meal: meal.toJson())),
              ),
            );
          },
        );
      }),
    );
  }
}
