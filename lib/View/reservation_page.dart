import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/reservation_controller.dart';

class ReservationPage extends StatefulWidget {
  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> with SingleTickerProviderStateMixin {
  final ReservationController reservController = Get.put(ReservationController());

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
      Get.snackbar("Error", "Please fill in all fields correctly", backgroundColor: Colors.redAccent);
      return;
    }

    await reservController.reserveTable(tableId, data);
  }

  void loadReservations() {
    final tableId = int.tryParse(tableIdController.text);
    if (tableId != null) {
      reservController.fetchTableReservations(tableId);
    } else {
      Get.snackbar("Error", "Please enter a valid table number", backgroundColor: Colors.redAccent);
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
    final theme = Theme.of(context);
    final accentColor = theme.primaryColor;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final cardColor = theme.cardColor;
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.black;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: accentColor,
          title: Text("Reservation System", style: theme.textTheme.titleLarge?.copyWith(color: Colors.white)),
          centerTitle: true,
          bottom: TabBar(
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            tabs: const [
              Tab(text: "Current Reservations"),
              Tab(text: "Make a New Reservation"),
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
                      labelText: "Table Number",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: loadReservations,
                    child: const Text("Load Reservations"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Obx(() {
                      if (reservController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (reservController.reservations.isEmpty) {
                        return Center(
                          child: Text("No current reservations.", style: theme.textTheme.bodyMedium),
                        );
                      }

                      return ListView.builder(
                        itemCount: reservController.reservations.length,
                        itemBuilder: (context, index) {
                          final reservation = reservController.reservations[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            color: cardColor,
                            child: ListTile(
                              leading: Icon(Icons.event_seat, color: accentColor),
                              title: Text("Reservation #${index + 1}", style: theme.textTheme.titleLarge),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("From: ${reservation.startTime}", style: theme.textTheme.bodyMedium),
                                  Text("To: ${reservation.endTime}", style: theme.textTheme.bodyMedium),
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
                      labelText: "Table Number",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text("Start Time", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(children: [
                    buildTimeInput("Day", startDay),
                    const SizedBox(width: 8),
                    buildTimeInput("Hour", startHour),
                    const SizedBox(width: 8),
                    buildTimeInput("Minute", startMinute),
                  ]),
                  const SizedBox(height: 20),
                  Text("End Time", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
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
                      foregroundColor: Colors.white,
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
