import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../screen/signup.dart';
import '../screen/VerifyAccountPage .dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_Parts.dart';
class SignUpController extends GetxController {
  static const String baseUrl = "http://192.168.1.102:8000/api";
  var isLoading = false.obs;
  var signUpMessage = "".obs;
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }
  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    const String endpoint = "/signup";
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
          "first_name": firstName,
          "last_name": lastName,
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
          signUpMessage.value = "تم تسجيل المستخدم بنجاح!";
          Get.snackbar("نجاح", signUpMessage.value, backgroundColor: Get.theme.primaryColor); 
          final CategoryController categoryController = Get.put(CategoryController());
          categoryController.fetchCategories();
          Get.to(() => VerifyAccountPage(email: email));
        } else {
          signUpMessage.value = jsonDecode(response.body)['message'] ?? "خطأ غير معروف";
        }
      } else {
        signUpMessage.value = jsonDecode(response.body)['message'] ?? "خطأ غير معروف";
      }
    } catch (error) {
      isLoading.value = false;
      signUpMessage.value = "حدث خطأ: $error";
    }
  }
}