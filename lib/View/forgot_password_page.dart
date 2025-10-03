import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/reset_controller.dart';

class ForgotPasswordPage extends StatelessWidget {
  final ResetController controller = Get.put(ResetController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = theme.primaryColor;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.white;
    final titleStyle = theme.textTheme.titleLarge ??
        TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: accentColor,
        elevation: 0,
        title: Text("Forgot Password", style: titleStyle.copyWith(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.email_outlined, size: 100, color: accentColor),
            const SizedBox(height: 20),
            Text("Tap to send verification code", style: titleStyle),
            const SizedBox(height: 30),
            Obx(() => controller.isLoading.value
                ? CircularProgressIndicator(color: accentColor)
                : ElevatedButton(
                    onPressed: controller.sendVerificationCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text("Send Code", style: TextStyle(fontSize: 18, color: Colors.white)),
                  )),
          ],
        ),
      ),
    );
  }
}
