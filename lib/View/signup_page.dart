import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controller/signup_controller.dart';

class SignUpPage extends StatelessWidget {
  final SignUpController signUpController = Get.put(SignUpController());

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color.fromARGB(255, 228, 184, 168)),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Icon(Icons.restaurant_menu, color: Color.fromARGB(255, 228, 184, 168), size: 50),
            const SizedBox(height: 20),
            const Text("Sign Up", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 228, 184, 168))),
            const SizedBox(height: 20),
            buildTextField("First Name", firstNameController),
            buildTextField("Last Name", lastNameController),
            buildTextField("Email", emailController),
            buildTextField("Password", passwordController, obscureText: true),
            const SizedBox(height: 20),
            Obx(() => signUpController.isLoading.value
                ? const CircularProgressIndicator()
                : MaterialButton(
                    onPressed: () {
                      signUpController.signUp(
                        firstName: firstNameController.text.trim(),
                        lastName: lastNameController.text.trim(),
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                      );
                    },
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50), side: const BorderSide(color: Color.fromARGB(255, 228, 184, 168))),
                    child: const Text("Sign Up", style: TextStyle(color: Color.fromARGB(255, 228, 184, 168), fontSize: 18, fontWeight: FontWeight.bold)),
                  )),
            const SizedBox(height: 20),
            Obx(() => Text(signUpController.signUpMessage.value, style: const TextStyle(color: Colors.red))),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color.fromARGB(255, 228, 184, 168)),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 228, 184, 168))),
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 228, 184, 168), width: 2)),
        ),
      ),
    );
  }
}
