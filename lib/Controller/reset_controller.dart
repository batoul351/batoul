import 'package:get/get.dart';
import '../Service/reset_service.dart';
import '../View/code_verification_page.dart';
class ResetController extends GetxController {
  final ResetService service = ResetService();
  var isLoading = false.obs;

  Future<void> sendVerificationCode() async {
    isLoading.value = true;
    final response = await service.sendCode();

    if (response == null) {
      Get.snackbar("خطأ", "فشل الاتصال بالسيرفر", backgroundColor: Get.theme.colorScheme.error);
    } else if (response.statusCode == 200) {
      Get.snackbar("نجاح", "تم إرسال كود التحقق", backgroundColor: Get.theme.colorScheme.primary);
Get.to(() => CodeVerificationPage());
    } else {
      Get.snackbar("خطأ", "فشل إرسال الكود: ${response.statusCode}", backgroundColor: Get.theme.colorScheme.error);
    }

    isLoading.value = false;
  }

  Future<void> changePassword(String code, String newPassword) async {
    isLoading.value = true;
    final response = await service.changePassword(code, newPassword);

    if (response == null) {
      Get.snackbar("خطأ", "فشل الاتصال بالسيرفر", backgroundColor: Get.theme.colorScheme.error);
    } else if (response.statusCode == 200) {
      Get.snackbar("نجاح", "تم تغيير كلمة المرور", backgroundColor: Get.theme.colorScheme.primary);
      Get.offAllNamed("/login");
    } else {
      Get.snackbar("خطأ", "الكود غير صحيح أو فشل التغيير", backgroundColor: Get.theme.colorScheme.error);
    }

    isLoading.value = false;
  }
}
