import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

class ThemeController extends GetxController {
  final box = GetStorage();

  RxBool isDark = false.obs;
  Rx<Color> accentColor = const Color(0xFFE2B09E).obs; // اللون الوردي الأساسي

  @override
  void onInit() {
    super.onInit();
    int? savedColor = box.read('accentColor');
    if (savedColor != null) {
      accentColor.value = Color(savedColor);
    }

    bool? savedDark = box.read('isDarkMode');
    if (savedDark != null) {
      isDark.value = savedDark;
    }
  }

  void toggleTheme() {
    isDark.value = !isDark.value;
    box.write('isDarkMode', isDark.value);
  }

  void changeAccentColor(Color newColor) {
    accentColor.value = newColor;
    box.write('accentColor', newColor.value);
  }

  void resetTheme() {
    accentColor.value = const Color(0xFFE2B09E);
    isDark.value = false;
    box.remove('accentColor');
    box.remove('isDarkMode');
  }
}
