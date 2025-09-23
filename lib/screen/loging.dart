import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api_service/api_login_service.dart';
import '../screen/forgetPassword.dart';

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
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            SizedBox(height: 20), // ← تم تقليل المسافة قليلاً
            _buildProfileIcon(context),
            SizedBox(height: 16),
            Text("Log In", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 24),
            buildTextField("Email", emailController),
            SizedBox(height: 12),
            buildTextField("Password", passwordController, obscureText: true),
            SizedBox(height: 20),
            Obx(() => loginController.isLoading.value
                ? CircularProgressIndicator()
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
                    child: Text("Log In", style: TextStyle(color: baseColor, fontSize: 18, fontWeight: FontWeight.bold)),
                  )),
            SizedBox(height: 20),
            MaterialButton(
              onPressed: () => Get.to(() => ForgotPasswordPage()),
              color: baseColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              child: Text("Forgot Password?", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 20),
            Obx(() => Text(loginController.loginMessage.value, style: TextStyle(color: Colors.red))),
          ],
        ),
      ),
    );
  }

  // ⭐ أيقونة داخل دائرة بظل بسيط
  Widget _buildProfileIcon(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.height * 0.2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.1),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Icon(
        Icons.person,
        size: MediaQuery.of(context).size.height * 0.12,
        color: Colors.white,
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
      ),
    );
  }
}
