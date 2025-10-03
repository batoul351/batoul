import 'package:get/get.dart';
import '../Service/reset_service.dart';

class ResetController extends GetxController {
  final isLoading = false.obs;
  final ResetService service = ResetService();

  void changePassword(String code, String newPassword) async {
    isLoading.value = true;

    final response = await service.changePassword(code, newPassword);

    isLoading.value = false;

    if (response != null && response.statusCode == 200) {
      Get.snackbar("نجاح", "تم تغيير كلمة المرور بنجاح");
      Get.offAllNamed("/login");
    } else {
      Get.snackbar("فشل", "الكود غير صحيح أو انتهت صلاحيته");
    }
  }
}
