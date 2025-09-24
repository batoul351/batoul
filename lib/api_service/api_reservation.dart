import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

class ReservationController extends GetxController {
  static const String baseUrl = "http://192.168.1.102:8000/api";

  final Dio dio = Dio();
  final box = GetStorage();

  var isLoading = false.obs;
  var tables = <Map<String, dynamic>>[].obs;

  String? getToken() {
    return box.read("access_token");
  }

  Future<void> fetchTableReservations(int tableId) async {
    try {
      isLoading.value = true;
      final token = getToken();

      if (token == null || token.isEmpty) {
        Get.snackbar("تنبيه", "الرجاء تسجيل الدخول أولاً", backgroundColor: Colors.orange);
        return;
      }

      final response = await dio.get(
        "$baseUrl/showtimeReserv/$tableId",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final list = response.data['message'];
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

  Future<void> reserveTable(int tableId, Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      final token = getToken();

      if (token == null || token.isEmpty) {
        Get.snackbar("تنبيه", "الرجاء تسجيل الدخول أولاً", backgroundColor: Colors.orange);
        return;
      }

      final response = await dio.post(
        "$baseUrl/reserve/$tableId",
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      final result = response.data;

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
