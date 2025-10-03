import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'Controller/theme_controller.dart';
import '../View/home_page.dart'; 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(ThemeController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isDark = themeController.isDark.value;

      // 🎨 اللون الأساسي حسب الوضع
      final Color accent = isDark ? Colors.blue : const Color(0xFFE2B09E);
      final Color background = isDark ? Colors.black : Colors.white;
      final Color foreground = isDark ? Colors.white : Colors.black;
      final Color cardColor = isDark ? Colors.grey[900]! : Colors.white;

      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: accent,
          scaffoldBackgroundColor: background,
          appBarTheme: AppBarTheme(
            backgroundColor: accent,
            foregroundColor: foreground,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: accent,
              foregroundColor: foreground,
            ),
          ),
          iconTheme: IconThemeData(color: accent),
          cardColor: cardColor,
          textTheme: TextTheme(
            bodyMedium: TextStyle(color: foreground),
            titleLarge: TextStyle(color: foreground, fontWeight: FontWeight.bold),
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedItemColor: accent,
            unselectedItemColor: Colors.grey,
            backgroundColor: background,
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: accent,
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: AppBarTheme(
            backgroundColor: accent,
            foregroundColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: accent,
              foregroundColor: Colors.white,
            ),
          ),
          iconTheme: IconThemeData(color: accent),
          cardColor: Colors.grey[900],
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.white),
            titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedItemColor: accent,
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.black,
          ),
        ),
        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
        home: HomePage(),
      );
    });
  }
}
