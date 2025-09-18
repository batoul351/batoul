import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api_service/api_verify_service.dart';

class VerifyAccountPage extends StatelessWidget {
  final String email;
  VerifyAccountPage({required this.email});

  final List<TextEditingController> controllers = List.generate(6, (index) => TextEditingController());
  final VerifyAccountController verifyController = Get.put(VerifyAccountController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 200, 190),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 235, 200, 190),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.verified, color: Colors.white, size: MediaQuery.of(context).size.height * 0.1),
            SizedBox(height: 20),
            Text("Verify Account", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                6,
                (index) => SizedBox(
                  width: MediaQuery.of(context).size.width * 0.1,
                  child: TextField(
                    controller: controllers[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    decoration: InputDecoration(
                      counterText: "",
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
                    ),
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Obx(() => verifyController.isLoading.value
                ? CircularProgressIndicator()
                : MaterialButton(
                    onPressed: () {
                      final code = controllers.map((controller) => controller.text).join();
                      if (code.length == 6) {
                        verifyController.verifyAccount(email: email, code: code);
                      } else {
                        Get.snackbar("Error", "Please enter a 6-digit verification code", backgroundColor: Colors.orange);
                      }
                    },
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50), side: BorderSide(color: Colors.white)),
                    child: Text("Verify", style: TextStyle(color: const Color.fromARGB(255, 235, 200, 190), fontSize: 18, fontWeight: FontWeight.bold)),
                  )),
            SizedBox(height: 20),
            Obx(() => Text(verifyController.verificationMessage.value, style: TextStyle(color: Colors.red))),
          ],
        ),
      ),
    );
  }
}
