import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/reservation_controller.dart';

class ReservationPage extends StatefulWidget {
  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> with SingleTickerProviderStateMixin {
  final ReservationController reservController = Get.put(ReservationController());
  final Color accentColor = const Color.fromARGB(255, 226, 176, 158);

  final tableIdController = TextEditingController();
  final startDay = TextEditingController();
  final startHour = TextEditingController();
  final startMinute = TextEditingController();
  final endDay = TextEditingController();
  final endHour = TextEditingController();
  final endMinute = TextEditingController();

  void submitReservation() async {
    final tableId = int.tryParse(tableIdController.text);
    final data = {
      "start_day": int.tryParse(startDay.text),
      "start_hour": int.tryParse(startHour.text),
      "start_minute": int.tryParse(startMinute.text),
      "end_day": int.tryParse(endDay.text),
      "end_hour": int.tryParse(endHour.text),
      "end_minute": int.tryParse(endMinute.text),
    };

    if (tableId == null || data.values.any((v) => v == null)) {
      Get.snackbar("خطأ", "يرجى ملء جميع الحقول بشكل صحيح", backgroundColor: Colors.redAccent);
      return;
    }

    await reservController.reserveTable(tableId, data);
  }

  void loadReservations() {
    final tableId = int.tryParse(tableIdController.text);
    if (tableId != null) {
      reservController.fetchTableReservations(tableId);
    } else {
      Get.snackbar("خطأ", "يرجى إدخال رقم طاولة صالح", backgroundColor: Colors.redAccent);
    }
  }

  Widget buildTimeInput(String label, TextEditingController controller) {
    return Expanded(
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: accentColor,
          title: const Text("نظام الحجوزات"),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: "الحجوزات الحالية"),
              Tab(text: "إجراء حجز جديد"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: tableIdController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "رقم الطاولة",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: loadReservations,
                    child: const Text("تحميل الحجوزات"),
                    style: ElevatedButton.styleFrom(backgroundColor: accentColor),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Obx(() {
                      if (reservController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (reservController.reservations.isEmpty) {
                        return const Center(child: Text("لا توجد حجوزات حالية."));
                      }

                      return ListView.builder(
                        itemCount: reservController.reservations.length,
                        itemBuilder: (context, index) {
                          final reservation = reservController.reservations[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            color: accentColor.withOpacity(0.1),
                            child: ListTile(
                              leading: Icon(Icons.event_seat, color: accentColor),
                              title: Text("حجز رقم ${index + 1}", style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("من: ${reservation.startTime}"),
                                  Text("إلى: ${reservation.endTime}"),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),

            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    controller: tableIdController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "رقم الطاولة",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text("وقت البدء", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(children: [
                    buildTimeInput("اليوم", startDay),
                    const SizedBox(width: 8),
                    buildTimeInput("الساعة", startHour),
                    const SizedBox(width: 8),
                    buildTimeInput("الدقيقة", startMinute),
                  ]),
                  const SizedBox(height: 20),
                  const Text("وقت الانتهاء", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(children: [
                    buildTimeInput("اليوم", endDay),
                    const SizedBox(width: 8),
                    buildTimeInput("الساعة", endHour),
                    const SizedBox(width: 8),
                    buildTimeInput("الدقيقة", endMinute),
                  ]),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: submitReservation,
                    child: const Text("تأكيد الحجز"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
