import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import '../service/profile_service.dart';

class ProfileController extends GetxController {
  final cityController = TextEditingController();
  final streetController = TextEditingController();
  final phoneController = TextEditingController();

  final imagePath = ''.obs;
  final imageFile = Rxn<File>();
  final hasProfile = false.obs;

  final ProfileService service = ProfileService();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  void pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      imageFile.value = File(picked.path);
    }
  }

  Future<void> submitProfile() async {
    if (hasProfile.value) {
      Get.snackbar('موجود', 'لديك ملف شخصي بالفعل');
      return;
    }

    final token = service.getToken();
    if (token == null || token.isEmpty) {
      Get.snackbar('توكن مفقود', 'يرجى تسجيل الدخول أولاً');
      return;
    }

    if (imageFile.value == null || !await imageFile.value!.exists()) {
      Get.snackbar('الصورة مطلوبة', 'يرجى اختيار صورة صالحة قبل الإرسال');
      return;
    }

    try {
      final formData = dio.FormData.fromMap({
        'city': cityController.text,
        'street': streetController.text,
        'phone': phoneController.text,
        'image': await dio.MultipartFile.fromFile(
          imageFile.value!.path,
          filename: imageFile.value!.path.split('/').last,
        ),
      });

      final response = await service.submitProfile(formData);

      if (response?.statusCode == 200) {
        Get.snackbar('نجاح', 'تم إنشاء الملف الشخصي بنجاح');
        fetchProfile();
      } else if (response?.statusCode == 409) {
        hasProfile.value = true;
        Get.snackbar('موجود مسبقًا', 'الملف الشخصي موجود بالفعل');
      } else {
        Get.snackbar('فشل', 'تعذر إنشاء الملف الشخصي: ${response?.statusCode}');
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء إرسال البيانات: $e');
    }
  }

  Future<void> fetchProfile() async {
    final response = await service.fetchProfile();

    if (response?.statusCode == 200) {
      final data = response!.data;
      if (data['message'] != null && data['message'].isNotEmpty) {
        final profile = data['message'][0];
        cityController.text = profile['city']?.toString() ?? '';
        streetController.text = profile['street']?.toString() ?? '';
        phoneController.text = profile['phone']?.toString() ?? '';
        imagePath.value = 'http://192.168.1.102:8000/' + profile['image'];
        imageFile.value = null;
        hasProfile.value = true;
      }
    } else {
      Get.snackbar('خطأ', 'تعذر جلب الملف الشخصي');
    }
  }
}
