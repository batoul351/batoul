import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api_service/api_favorite.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoriteController favoriteController = Get.put(FavoriteController());

  @override
  void initState() {
    super.initState();
    favoriteController.fetchFavoritesFromLaravel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("المفضلة", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 226, 176, 158),
      ),
      body: Obx(() {
        if (favoriteController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final favorites = favoriteController.favorites;

        if (favorites.isEmpty) {
          return const Center(
            child: Text("لا توجد وجبات مفضلة", style: TextStyle(fontSize: 18)),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: favorites.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.6,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            final meal = favorites[index];

            return Card(
              color: const Color.fromARGB(255, 226, 176, 158),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/food.png',
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${meal['id']}",
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 18, color: Colors.white),
                        padding: const EdgeInsets.all(0),
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          favoriteController.deleteFavorite(meal['id']);
                        },
                      ),
                    ],
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
