import 'dart:convert';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import '../screen/signup.dart';
import '../screen/VerifyAccountPage .dart';
import 'api_Parts.dart';

class SignUpController extends GetxController {
  static const String baseUrl = "http://192.168.1.103:8000/api";
  final Dio dio = Dio();
  final GetStorage storage = GetStorage();

  var isLoading = false.obs;
  var signUpMessage = "".obs;

  void saveToken(String token) {
    storage.write('access_token', token);
  }

  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    const String endpoint = "/signup";
    final String url = baseUrl + endpoint;

    try {
      isLoading.value = true;

      final response = await dio.post(
        url,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
        ),
        data: {
          "first_name": firstName,
          "last_name": lastName,
          "email": email,
          "password": password,
        },
      );

      isLoading.value = false;

      if (response.statusCode == 201) {
        final responseData = response.data;
        if (responseData.containsKey("token")) {
          String token = responseData["token"];
          saveToken(token);
          signUpMessage.value = "تم تسجيل المستخدم بنجاح!";
          Get.snackbar("نجاح", signUpMessage.value, backgroundColor: Get.theme.primaryColor);

          final CategoryController categoryController = Get.put(CategoryController());
          categoryController.fetchCategories();

          Get.to(() => VerifyAccountPage(email: email));
        } else {
          signUpMessage.value = responseData['message'] ?? "خطأ غير معروف";
        }
      } else {
        signUpMessage.value = response.data['message'] ?? "خطأ غير معروف";
      }
    } catch (error) {
      isLoading.value = false;
      signUpMessage.value = "حدث خطأ: $error";
    }
  }
}
