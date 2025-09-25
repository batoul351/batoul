import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import '../screen/Parts.dart';

class LoginController extends GetxController {
  static const String baseUrl = "http://192.168.1.105:8000/api";
  final Dio dio = Dio();
  final box = GetStorage();

  var isLoading = false.obs;
  var loginMessage = "".obs;

  Future<void> login({required String email, required String password}) async {
    final String url = "$baseUrl/login";

    try {
      isLoading.value = true;

      final response = await dio.post(
        url,
        data: {
          "email": email,
          "password": password,
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
        ),
      );

      isLoading.value = false;

      if (response.statusCode == 201) {
        final responseData = response.data;

        if (responseData.containsKey("token")) {
          String token = responseData["token"];

          box.write("access_token", token);
          box.write("userEmail", email);

          loginMessage.value = "تم تسجيل الدخول بنجاح!";
          Get.snackbar("نجاح", loginMessage.value, backgroundColor: Get.theme.primaryColor);
          Get.offAll(() => WelcomePage());
        } else {
          loginMessage.value = "لم يتم استلام رمز المصادقة، يرجى المحاولة مرة أخرى.";
        }
      } else if (response.statusCode == 401) {
        loginMessage.value = "البريد الإلكتروني أو كلمة المرور غير صحيحة.";
      } else {
        loginMessage.value = "خطأ غير متوقع: ${response.data}";
      }
    } catch (error) {
      isLoading.value = false;
      loginMessage.value = "حدث خطأ أثناء الاتصال بالسيرفر: $error";
    }
  }
}
