import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../Service/signup_service.dart';
import '../View/verify_account_page.dart'; 
import 'package:flutter/material.dart';
class SignUpController extends GetxController {
  var isLoading = false.obs;
  var signUpMessage = "".obs;
  final box = GetStorage();

  void saveToken(String token) {
    box.write('access_token', token);
  }

  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    isLoading.value = true;

    final response = await SignUpService.registerUser(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );

    isLoading.value = false;

    if (response['success']) {
      saveToken(response['token']);
      signUpMessage.value = "تم تسجيل المستخدم بنجاح!";

      Get.snackbar("نجاح", signUpMessage.value, backgroundColor: Get.theme.primaryColor);

        Get.to(() => VerifyAccountPage(email: email));

    } else {
      signUpMessage.value = response['message'] ?? "خطأ غير معروف";
      Get.snackbar("خطأ", signUpMessage.value, backgroundColor: Colors.red);
    }
  }
}
