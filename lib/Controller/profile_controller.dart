import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart'as dio;
import '../Model/profile_model.dart';
import '../Service/profile_service.dart';

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
      imagePath.value = picked.path;
      imageFile.value = File(picked.path);
    }
  }

  Future<void> submitProfile() async {
    if (hasProfile.value) {
      Get.snackbar('موجود', 'لديك ملف شخصي بالفعل');
      return;
    }

    if (imageFile.value == null || !await imageFile.value!.exists()) {
      Get.snackbar('الصورة مطلوبة', 'يرجى اختيار صورة صالحة قبل الإرسال');
      return;
    }

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

    if (response == null) {
      Get.snackbar('خطأ', 'فشل الاتصال بالسيرفر');
    } else if (response.statusCode == 200) {
      Get.snackbar('نجاح', 'تم إنشاء الملف الشخصي بنجاح');
      fetchProfile();
    } else if (response.statusCode == 409) {
      hasProfile.value = true;
      Get.snackbar('موجود مسبقًا', 'الملف الشخصي موجود بالفعل');
    } else {
      Get.snackbar('فشل', 'تعذر إنشاء الملف الشخصي: ${response.statusCode}');
    }
  }

  Future<void> fetchProfile() async {
    final response = await service.fetchProfile();

    if (response != null && response.statusCode == 200) {
      final data = response.data;
      if (data['message'] != null && data['message'].isNotEmpty) {
        final profile = ProfileModel.fromJson(data['message'][0]);
        cityController.text = profile.city;
        streetController.text = profile.street;
        phoneController.text = profile.phone;
        imagePath.value = profile.image;
        imageFile.value = null;
        hasProfile.value = true;
      }
    } else {
      Get.snackbar('خطأ', 'تعذر جلب الملف الشخصي');
    }
  }
}
