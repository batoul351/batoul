import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controller/verify_account_controller.dart';

class VerifyAccountPage extends StatelessWidget {
  final String email;
  VerifyAccountPage({required this.email});

  final List<TextEditingController> controllers = List.generate(6, (_) => TextEditingController());
  final VerifyAccountController verifyController = Get.put(VerifyAccountController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = theme.primaryColor;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: accentColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.verified, color: accentColor, size: MediaQuery.of(context).size.height * 0.1),
            const SizedBox(height: 20),
            Text("Verify Account", style: theme.textTheme.titleLarge?.copyWith(fontSize: 30, fontWeight: FontWeight.bold, color: accentColor)),
            const SizedBox(height: 20),
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
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: accentColor)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: accentColor, width: 2)),
                    ),
                    style: TextStyle(fontSize: 24, color: accentColor),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Obx(() => verifyController.isLoading.value
                ? const CircularProgressIndicator()
                : MaterialButton(
                    onPressed: () {
                      final code = controllers.map((c) => c.text).join();
                      if (code.length == 6) {
                        verifyController.verifyAccount(email: email, code: code);
                      } else {
                        Get.snackbar("Error", "Please enter a 6-digit verification code", backgroundColor: Colors.orange);
                      }
                    },
                    color: backgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: BorderSide(color: accentColor),
                    ),
                    child: Text("Verify", style: TextStyle(color: accentColor, fontSize: 18, fontWeight: FontWeight.bold)),
                  )),
            const SizedBox(height: 20),
            Obx(() => Text(
              verifyController.verificationMessage.value,
              style: const TextStyle(color: Colors.red),
            )),
          ],
        ),
      ),
    );
  }
}
