import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../screen/Parts.dart';

class LoginController extends GetxController {
  static const String baseUrl = "http://192.168.1.102:8000/api";

  var isLoading = false.obs;
  var loginMessage = "".obs;

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  Future<void> login({required String email, required String password}) async {
    final url = Uri.parse("$baseUrl/login");

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
          "password": password,
        }),
      );

      isLoading.value = false;

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        if (responseData.containsKey("token")) {
          String token = responseData["token"];
          await saveToken(token);

          loginMessage.value = "تم تسجيل الدخول بنجاح!";
          Get.snackbar("نجاح", loginMessage.value, backgroundColor: Get.theme.primaryColor);
          Get.offAll(() => WelcomePage());
        } else {
          loginMessage.value = "لم يتم استلام رمز المصادقة، يرجى المحاولة مرة أخرى.";
        }
      } else if (response.statusCode == 401) {
        loginMessage.value = "البريد الإلكتروني أو كلمة المرور غير صحيحة.";
      } else {
        loginMessage.value = "خطأ غير متوقع: ${response.body}";
      }
    } catch (error) {
      isLoading.value = false;
      loginMessage.value = "حدث خطأ أثناء الاتصال بالسيرفر: $error";
    }
  }
}
