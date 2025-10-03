import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/favorite_controller.dart';

class FavoritePage extends StatelessWidget {
  final FavoriteController favoriteController = Get.put(FavoriteController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = theme.primaryColor;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final cardColor = theme.cardColor;
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.black;

    favoriteController.fetchFavorites();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text("Favorite", style: theme.textTheme.titleLarge?.copyWith(fontSize: 24, color: Colors.white)),
        backgroundColor: accentColor,
        centerTitle: true,
        elevation: 4,
      ),
      body: Obx(() {
        if (favoriteController.favoriteItems.isEmpty) {
          return Center(
            child: Text(
              "No favorites yet",
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 20, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: favoriteController.favoriteItems.length,
          itemBuilder: (context, index) {
            final item = favoriteController.favoriteItems[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 6, offset: const Offset(0, 3)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Meal ID: ${item.foodId}",
                    style: theme.textTheme.bodyMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () {
                      favoriteController.deleteFavorite(item.foodId);
                    },
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
