import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Controller/category_controller.dart';
import '../Model/category_model.dart';
import 'meals_page.dart';
import 'settings_page.dart';
import 'favorite_page.dart';
import 'reservation_page.dart';
import '../Controller/style_helper.dart'; 

class WelcomePage extends StatefulWidget {
  @override
  State<WelcomePage> createState() => _WelcomePageState();
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
      Get.snackbar("خطأ", " لا يمكن إجراء المكالمة",
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 1:
        Get.to(() => SettingsPage());
        break;
      case 2:
        Get.to(() => FavoritePage());
        break;
      case 4:
        Get.to(() => ReservationPage());
        break;
      default:
        setState(() {
          _selectedIndex = index;
        });
    }
  }

  Widget buildCategoryItem(CategoryModel category) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: getCardColor(context),
      elevation: 4,
      child: ListTile(
        leading: Icon(Icons.restaurant_menu, color: getAccent(context), size: 30),
        title: Text(
          category.name,
          style: getTitleStyle(context).copyWith(fontSize: 18),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
        onTap: () => Get.to(() => MealsPage(
            categoryId: category.id, categoryName: category.name)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getBackground(context),
      appBar: AppBar(
        backgroundColor: getAccent(context),
        elevation: 0,
        title: Text(
          "Food Categories",
          style: getTitleStyle(context).copyWith(
            color: getAppBarTextColor(context),
            fontSize: 22,
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
                  return Center(
                    child: Text("لا توجد فئات متاحة.", style: getBodyStyle(context)),
                  );
                }
                return ListView.builder(
                  itemCount: categoryController.categories.length,
                  itemBuilder: (context, index) {
                    final category = categoryController.categories[index];
                    return buildCategoryItem(category);
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
        tooltip: "اتصل بالمطعم",
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Notifications"),
          BottomNavigationBarItem(icon: Icon(Icons.event_seat), label: "Bookings"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: getBackground(context),
        onTap: _onItemTapped,
      ),
    );
  }
}
