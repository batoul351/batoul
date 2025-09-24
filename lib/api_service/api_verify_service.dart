import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import '../screen/Parts.dart';

class VerifyAccountController extends GetxController {
  static const String baseUrl = "http://192.168.1.102:8000/api";
  final Dio dio = Dio();
  final box = GetStorage();

  var isLoading = false.obs;
  var verificationMessage = "".obs;

  Future<void> verifyAccount({required String email, required String code}) async {
    const String endpoint = "/verification_signup";
    final String url = baseUrl + endpoint;

    try {
      isLoading.value = true;

      final response = await dio.post(
        url,
        data: {
          "email": email,
          "code": code,
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
        ),
      );

      isLoading.value = false;

      if (response.statusCode == 200) {
        final responseData = response.data;
        verificationMessage.value = responseData["message"] ?? "تم التحقق بنجاح.";

        box.write("isVerified", true);
        box.write("userEmail", email);

        Get.snackbar("نجاح", verificationMessage.value, backgroundColor: Get.theme.primaryColor);
        Get.offAll(() => WelcomePage());
      } else {
        final responseData = response.data;
        verificationMessage.value = responseData["message"] ?? "فشل التحقق.";
      }
    } catch (error) {
      isLoading.value = false;
      verificationMessage.value = "خطأ في الاتصال بالسيرفر: $error";
    }
  }
}
