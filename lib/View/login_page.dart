import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/login_controller.dart';
import '../View/ForgotPasswordPage.dart';

class LoginPage extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final baseColor = const Color.fromARGB(255, 235, 200, 190);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: baseColor,
      appBar: AppBar(
        backgroundColor: baseColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
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
            const Text("Log In", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 24),
            buildTextField("Email", emailController),
            const SizedBox(height: 12),
            buildTextField("Password", passwordController, obscureText: true),
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
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    child: const Text("Log In", style: TextStyle(color: Color.fromARGB(255, 235, 200, 190), fontSize: 18, fontWeight: FontWeight.bold)),
                  )),
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: () => Get.to(() => ForgotPasswordPage()),
              color: baseColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              child: const Text("Forgot Password?", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            Obx(() => Text(loginController.loginMessage.value, style: const TextStyle(color: Colors.red))),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileIcon(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.height * 0.2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.1),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 6)),
        ],
      ),
      child: Icon(Icons.person, size: MediaQuery.of(context).size.height * 0.12, color: Colors.white),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
      ),
    );
  }
}
