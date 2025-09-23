import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  final cityController = TextEditingController();
  final streetController = TextEditingController();
  final phoneController = TextEditingController();

  final imagePath = ''.obs;
  final imageFile = Rxn<File>();
  final hasProfile = false.obs;

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
      Get.snackbar('Profile Exists', 'You already have a profile.');
      return;
    }

    final token = await getToken();
    if (token == null) {
      Get.snackbar('Token Error', 'Authentication token not found');
      return;
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.1.102:8000/api/profile'),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['city'] = cityController.text;
    request.fields['street'] = streetController.text;
    request.fields['phone'] = phoneController.text;
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.value!.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      Get.snackbar('Success', 'Profile created successfully');
      fetchProfile();
    } else if (response.statusCode == 409) {
      hasProfile.value = true;
      Get.snackbar('Exists', 'Profile already exists');
    } else {
      Get.snackbar('Error', 'Failed to create profile');
    }
  }

  Future<void> fetchProfile() async {
    final token = await getToken();
    if (token == null) return;

    final response = await http.get(
      Uri.parse('http://192.168.1.102:8000/api/getProfile'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['message'] != null && data['message'].isNotEmpty) {
        final profile = data['message'][0];
        cityController.text = profile['city'] ?? '';
        streetController.text = profile['street'] ?? '';
        phoneController.text = profile['phone'].toString();
        imagePath.value = 'http://192.168.1.102:8000/' + profile['image'];
        imageFile.value = null;
        hasProfile.value = true;
      }
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }
}
