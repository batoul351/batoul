import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'password_reset_page.dart';

class CodeVerificationPage extends StatelessWidget {
  final List<TextEditingController> controllers =
      List.generate(6, (_) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = theme.primaryColor;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.white;
    final cardColor = theme.cardColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: accentColor,
        elevation: 0,
        title: Text("Verify Code", style: theme.textTheme.titleLarge?.copyWith(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outline, size: 100, color: accentColor),
            const SizedBox(height: 20),
            Text("Enter Verification Code", style: theme.textTheme.titleLarge),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                6,
                (index) => SizedBox(
                  width: 45,
                  child: TextField(
                    controller: controllers[index],
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      counterText: "",
                      filled: true,
                      fillColor: cardColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: accentColor),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                final code = controllers.map((c) => c.text).join();

                if (code.length != 6 || code.contains(RegExp(r'\D'))) {
                  Get.snackbar("خطأ", "يرجى إدخال رمز مكون من 6 أرقام صحيحة");
                  return;
                }

                Get.to(() => PasswordResetPage(), arguments: code);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: Text("Confirm Code", style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
