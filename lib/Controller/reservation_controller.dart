import 'package:get/get.dart';
import '../Service/reservation_service.dart';
import '../Model/reservation_model.dart';
import 'package:flutter/material.dart';

class ReservationController extends GetxController {
  final ReservationService service = ReservationService();

  var isLoading = false.obs;
  var reservations = <ReservationModel>[].obs;

  Future<void> fetchTableReservations(int tableId) async {
    isLoading.value = true;
    final response = await service.fetchReservations(tableId);

    if (response == null) {
      Get.snackbar("خطأ", "فشل الاتصال بالسيرفر", backgroundColor: Colors.red);
      reservations.clear();
    } else if (response.statusCode == 200) {
      final list = response.data['message'];
      if (list is List) {
        reservations.value = list.map((e) => ReservationModel.fromJson(e)).toList();
      } else {
        reservations.clear();
        Get.snackbar("تنبيه", "لا توجد حجوزات لهذه الطاولة", backgroundColor: Colors.orange);
      }
    } else {
      reservations.clear();
      Get.snackbar("فشل", "فشل في جلب البيانات", backgroundColor: Colors.red);
    }

    isLoading.value = false;
  }

  Future<void> reserveTable(int tableId, Map<String, dynamic> data) async {
    isLoading.value = true;
    final response = await service.reserveTable(tableId, data);

    if (response == null) {
      Get.snackbar("خطأ", "فشل الاتصال بالسيرفر", backgroundColor: Colors.red);
    } else if (response.statusCode == 200) {
      Get.snackbar("نجاح", response.data['message'] ?? 'تم الحجز بنجاح', backgroundColor: Colors.green);
    } else {
      Get.snackbar("فشل", response.data['message'] ?? 'لم يتم الحجز', backgroundColor: Colors.red);
    }

    isLoading.value = false;
  }
}
