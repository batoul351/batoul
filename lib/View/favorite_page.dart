import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/favorite_controller.dart';

class FavoritePage extends StatelessWidget {
  final FavoriteController favoriteController = Get.put(FavoriteController());

  @override
  Widget build(BuildContext context) {
    favoriteController.fetchFavorites();

    return Scaffold(
      appBar: AppBar(
        title: const Text("المفضلة", style: TextStyle(fontSize: 24)),
        backgroundColor: const Color(0xFFE2B09E),
        centerTitle: true,
        elevation: 4,
      ),
      body: Obx(() {
        if (favoriteController.favoriteItems.isEmpty) {
          return const Center(
            child: Text("لا توجد عناصر مفضلة",
                style: TextStyle(fontSize: 20, color: Colors.grey)),
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
                color: const Color(0xFFF6E7E0),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Meal ID: ${item.foodId}",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
