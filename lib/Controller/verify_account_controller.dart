import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../Model/verification_response_model.dart';
import '../Service/verify_account_service.dart';
import '../View/home_page.dart';

class VerifyAccountController extends GetxController {
  final box = GetStorage();
  var isLoading = false.obs;
  var verificationMessage = "".obs;

  Future<void> verifyAccount({required String email, required String code}) async {
    isLoading.value = true;

    final VerificationResponseModel response =
        await VerifyAccountService.verifyAccount(email: email, code: code);

    isLoading.value = false;
    verificationMessage.value = response.message;

    if (response.success) {
      box.write("isVerified", true);
      box.write("userEmail", email);
      Get.snackbar("نجاح", response.message, backgroundColor: Get.theme.primaryColor);
      Get.offAll(() => HomePage());
    } else {
      Get.snackbar("خطأ", response.message, backgroundColor: Colors.red);
    }
  }
}
