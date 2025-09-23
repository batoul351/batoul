import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api_service/api_reservation.dart';

class ReservationDashboard extends StatefulWidget {
  @override
  State<ReservationDashboard> createState() => _ReservationDashboardState();
}

class _ReservationDashboardState extends State<ReservationDashboard> with SingleTickerProviderStateMixin {
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
      Get.snackbar("Error", "Please fill in all fields correctly.", backgroundColor: Colors.redAccent);
      return;
    }

    await reservController.reserveTable(tableId, data);
  }

  void loadReservations() {
    final tableId = int.tryParse(tableIdController.text);
    if (tableId != null) {
      reservController.fetchTableReservations(tableId);
    } else {
      Get.snackbar("Error", "Please enter a valid table ID.", backgroundColor: Colors.redAccent);
    }
  }

  Widget buildTimeInput(String label, TextEditingController controller) {
    return Expanded(
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
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
          title: const Text("Reservation System"),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: "Current Reservations"),
              Tab(text: "New Reservation"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Display Reservations
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: tableIdController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Enter Table ID", border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: loadReservations,
                    child: const Text("Load Reservations"),
                    style: ElevatedButton.styleFrom(backgroundColor: accentColor),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Obx(() {
                      if (reservController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (reservController.tables.isEmpty) {
                        return const Center(child: Text("No current reservations."));
                      }

                      return ListView.builder(
                        itemCount: reservController.tables.length,
                        itemBuilder: (context, index) {
                          final table = reservController.tables[index];
                          final startTime = table['start_time'] ?? 'N/A';
                          final endTime = table['end_time'] ?? 'N/A';

                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            color: accentColor.withOpacity(0.1),
                            child: ListTile(
                              leading: Icon(Icons.event_seat, color: accentColor),
                              title: Text("Reservation #${index + 1}", style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("From: $startTime"),
                                  Text("To:   $endTime"),
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

            // Tab 2: Make Reservation
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    controller: tableIdController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Table ID", border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 20),
                  const Text("Start Time", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(children: [
                    buildTimeInput("Day", startDay),
                    const SizedBox(width: 8),
                    buildTimeInput("Hour", startHour),
                    const SizedBox(width: 8),
                    buildTimeInput("Minute", startMinute),
                  ]),
                  const SizedBox(height: 20),
                  const Text("End Time", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(children: [
                    buildTimeInput("Day", endDay),
                    const SizedBox(width: 8),
                    buildTimeInput("Hour", endHour),
                    const SizedBox(width: 8),
                    buildTimeInput("Minute", endMinute),
                  ]),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: submitReservation,
                    child: const Text("Confirm Reservation"),
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
