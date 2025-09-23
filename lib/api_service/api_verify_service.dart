import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../screen/Parts.dart';

class VerifyAccountController extends GetxController {
  static const String baseUrl = "http://192.168.1.102:8000/api";

  var isLoading = false.obs;
  var verificationMessage = "".obs;

  Future<void> verifyAccount({required String email, required String code}) async {
    const String endpoint = "/verification_signup";
    final url = Uri.parse(baseUrl + endpoint);

    try {
      isLoading.value = true;

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "email": email,
          "code": code,
        }),
      );

      isLoading.value = false;

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        verificationMessage.value = responseData["message"] ?? "Verification successful.";
        Get.snackbar("نجاح", verificationMessage.value, backgroundColor: Get.theme.primaryColor);
        Get.offAll(() => WelcomePage()); 
      } else {
        final responseData = jsonDecode(response.body);
        verificationMessage.value = responseData["message"] ?? "Verification failed.";
      }
    } catch (error) {
      isLoading.value = false;
      verificationMessage.value = "خطأ في الاتصال بالسيرفر: $error";
    }
  }
}
