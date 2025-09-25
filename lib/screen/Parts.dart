import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../api_service/api_Parts.dart';
import '../screen/meals.dart';
import '../screen/HomeReservationPage.dart';
import '../screen/profile.dart';
import '../screen/favorite_screen.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final CategoryController categoryController = Get.put(CategoryController());
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    categoryController.fetchCategories();
  }

  void callRestaurant(String phoneNumber) async {
    final Uri phoneUri = Uri.parse("tel:$phoneNumber");
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      Get.snackbar("Error", "⚠️ Unable to make the call", backgroundColor: Colors.red);
    }
  }

  void _onItemTapped(int index) {
    if (index == 5) {
      Get.to(() => ReservationDashboard());
    } else if (index == 1) {
      Get.to(() => ProfileScreen());
    } else if (index == 2) {
      Get.to(() => FavoriteScreen()); // ✅ الانتقال إلى صفحة المفضلة
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 226, 176, 158),
        elevation: 0,
        title: const Text(
          "Food Categories",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/b1.png',
                height: 350,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (categoryController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (categoryController.categories.isEmpty) {
                  return const Center(child: Text("No categories available."));
                }
                return ListView.builder(
                  itemCount: categoryController.categories.length,
                  itemBuilder: (context, index) {
                    return buildCategoryItem(categoryController.categories[index]);
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => callRestaurant("0983901162"),
        backgroundColor: Colors.green,
        child: const Icon(Icons.phone, color: Colors.white),
        tooltip: "Call the restaurant",
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favourite"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Notifications"),
          BottomNavigationBarItem(icon: Icon(Icons.event_seat), label: "Reservations"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget buildCategoryItem(Map<String, dynamic> category) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      elevation: 4,
      child: ListTile(
        leading: const Icon(Icons.restaurant_menu,
            color: Color.fromARGB(255, 226, 176, 158), size: 30),
        title: Text(
          category['name'] ?? "Unavailable",
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
        onTap: () => Get.to(() => MealsPage(
            categoryId: category["id"], categoryName: category["name"])),
      ),
    );
  }
}
