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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Icon(Icons.restaurant_menu, color: accentColor, size: 50),
            const SizedBox(height: 20),
            Text("Sign Up", style: theme.textTheme.titleLarge?.copyWith(fontSize: 30, fontWeight: FontWeight.bold, color: accentColor)),
            const SizedBox(height: 20),
            buildTextField(context, "First Name", firstNameController),
            buildTextField(context, "Last Name", lastNameController),
            buildTextField(context, "Email", emailController),
            buildTextField(context, "Password", passwordController, obscureText: true),
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
                    color: backgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: BorderSide(color: accentColor),
                    ),
                    child: Text("Sign Up", style: TextStyle(color: accentColor, fontSize: 18, fontWeight: FontWeight.bold)),
                  )),
            const SizedBox(height: 20),
            Obx(() => Text(signUpController.signUpMessage.value, style: const TextStyle(color: Colors.red))),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(BuildContext context, String label, TextEditingController controller, {bool obscureText = false}) {
    final accentColor = Theme.of(context).primaryColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: accentColor),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: accentColor)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: accentColor, width: 2)),
        ),
      ),
    );
  }
}
