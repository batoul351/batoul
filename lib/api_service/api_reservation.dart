import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class ReservationController extends GetxController {
  static const String baseUrl = "http://192.168.1.102:8000/api";

  var isLoading = false.obs;
  var tables = <Map<String, dynamic>>[].obs;

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  /// دالة جلب الحجوزات لطاولة معيّنة باستخدام endpoint showtimeReserv/{id}
  Future<void> fetchTableReservations(int tableId) async {
    try {
      isLoading.value = true;
      final token = await getToken();

      if (token == null || token.isEmpty) {
        Get.snackbar("تنبيه", "الرجاء تسجيل الدخول أولاً", backgroundColor: Colors.orange);
        return;
      }

      final response = await http.get(
        Uri.parse("$baseUrl/showtimeReserv/$tableId"),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = data['message'];

        if (list is List) {
          tables.value = List<Map<String, dynamic>>.from(list);
        } else {
          tables.clear();
          Get.snackbar("تنبيه", "لا توجد حجوزات لهذه الطاولة", backgroundColor: Colors.orange);
        }
      } else {
        tables.clear();
        Get.snackbar("فشل", "فشل في جلب البيانات من الخادم", backgroundColor: Colors.red);
      }
    } catch (e) {
      tables.clear();
      Get.snackbar("خطأ", "حدث خطأ في الاتصال: $e", backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  /// دالة تنفيذ الحجز لطاولة معيّنة
  Future<void> reserveTable(int tableId, Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      final token = await getToken();

      if (token == null || token.isEmpty) {
        Get.snackbar("تنبيه", "الرجاء تسجيل الدخول أولاً", backgroundColor: Colors.orange);
        return;
      }

      final response = await http.post(
        Uri.parse("$baseUrl/reserve/$tableId"),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      final result = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Get.snackbar("نجاح", result['message'] ?? 'تم الحجز بنجاح', backgroundColor: Colors.green);
      } else {
        Get.snackbar("فشل", result['message'] ?? 'لم يتم الحجز', backgroundColor: Colors.red);
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدثت مشكلة أثناء الحجز: $e", backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }
}
