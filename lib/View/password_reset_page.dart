import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/reset_controller.dart';

class PasswordResetPage extends StatelessWidget {
  final TextEditingController passwordController = TextEditingController();
  final ResetController controller = Get.find();
  final String code = Get.arguments;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = theme.primaryColor;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.white;
    final cardColor = theme.cardColor;
    final titleStyle = theme.textTheme.titleLarge ??
        TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: accentColor,
        elevation: 0,
        title: Text("Reset Password", style: titleStyle.copyWith(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.vpn_key_outlined, size: 100, color: accentColor),
            const SizedBox(height: 20),
            Text("Enter New Password", style: titleStyle),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText: "New Password",
                labelStyle: TextStyle(color: textColor),
                filled: true,
                fillColor: cardColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 30),
            Obx(() => controller.isLoading.value
                ? CircularProgressIndicator(color: accentColor)
                : ElevatedButton.icon(
                    onPressed: () => controller.changePassword(code, passwordController.text),
                    icon: Icon(Icons.check, color: textColor),
                    label: Text("Reset Password", style: TextStyle(fontSize: 18, color: textColor)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: textColor,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}
