import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../Service/login_service.dart';
import '../View/category_page.dart'; 
import 'package:flutter/material.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  var loginMessage = "".obs;
  final box = GetStorage();

  Future<void> login({required String email, required String password}) async {
    isLoading.value = true;

    final response = await LoginService.login(email: email, password: password);

    isLoading.value = false;
    loginMessage.value = response['message'];

    if (response['success']) {
      box.write("access_token", response['token']);
      box.write("userEmail", email);

      Get.snackbar("نجاح", response['message'], backgroundColor: Colors.green);

      Get.offAll(() => WelcomePage());
    } else {
      Get.snackbar("خطأ", response['message'], backgroundColor: Colors.red);
    }
  }
}
