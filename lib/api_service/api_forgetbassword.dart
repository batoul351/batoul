import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AuthService {
  final String baseUrl = "http://192.168.1.103:8000/api"; 

  Future<void> sendVerificationCode(String token) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/ForgetPassword"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      final data = jsonDecode(response.body);
      Get.snackbar("تم الإرسال", data["message : "] ?? "تم إرسال الكود", backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar("خطأ", "فشل في إرسال الكود", backgroundColor: Colors.red);
    }
  }

  Future<void> changePassword(String token, String code, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/ChangePassword"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "code": code,
          "new_password": newPassword,
        }),
      );

      final data = jsonDecode(response.body);
      Get.snackbar("النتيجة", data["massege"] ?? "تم التغيير", backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar("خطأ", "فشل في تغيير كلمة المرور", backgroundColor: Colors.red);
    }
  }
}
