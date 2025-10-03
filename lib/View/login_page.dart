import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/login_controller.dart';
import '../View/forgot_password_page.dart';

class LoginPage extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).primaryColor;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: accentColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: textColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildProfileIcon(context),
            const SizedBox(height: 16),
            Text(
              "Log In",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
            ),
            const SizedBox(height: 24),
            buildTextField("Email", emailController, context),
            const SizedBox(height: 12),
            buildTextField("Password", passwordController, context, obscureText: true),
            const SizedBox(height: 20),
            Obx(() => loginController.isLoading.value
                ? const CircularProgressIndicator()
                : MaterialButton(
                    onPressed: () {
                      final email = emailController.text.trim();
                      final password = passwordController.text.trim();
                      if (email.isNotEmpty && password.isNotEmpty) {
                        loginController.login(email: email, password: password);
                      } else {
                        Get.snackbar("خطأ", "يرجى تعبئة جميع الحقول", backgroundColor: Colors.orange);
                      }
                    },
                    color: textColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    child: Text(
                      "Log In",
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: () => Get.to(() => ForgotPasswordPage()),
              color: accentColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              child: Text(
                "Forgot Password?",
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Obx(() => Text(
                  loginController.loginMessage.value,
                  style: const TextStyle(color: Colors.red),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileIcon(BuildContext context) {
    final accentColor = Theme.of(context).primaryColor;

    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.height * 0.2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: accentColor.withOpacity(0.1),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 6)),
        ],
      ),
      child: Icon(
        Icons.person,
        size: MediaQuery.of(context).size.height * 0.12,
        color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white,
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, BuildContext context,
      {bool obscureText = false}) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white;

    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: textColor),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: textColor)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: textColor, width: 2)),
      ),
    );
  }
}
