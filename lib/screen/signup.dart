import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api_service/api_sign_up_service.dart';

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
          icon: Icon(Icons.arrow_back_ios, color: Color.fromARGB(255, 228, 184, 168)),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Icon(Icons.restaurant_menu, color: Color.fromARGB(255, 228, 184, 168), size: 50),
              SizedBox(height: 20),
              Text("Sign Up", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 228, 184, 168))),
              SizedBox(height: 20),
              buildTextField("First Name", firstNameController),
              SizedBox(height: 10),
              buildTextField("Last Name", lastNameController),
              SizedBox(height: 10),
              buildTextField("Email", emailController),
              SizedBox(height: 10),
              buildTextField("Password", passwordController, obscureText: true),
              SizedBox(height: 20),
              Obx(() => signUpController.isLoading.value
                  ? CircularProgressIndicator()
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50), side: BorderSide(color: Color.fromARGB(255, 228, 184, 168))),
                      child: Text("Sign Up", style: TextStyle(color: Color.fromARGB(255, 228, 184, 168), fontSize: 18, fontWeight: FontWeight.bold)),
                    )),

              SizedBox(height: 20),
              Obx(() => Text(signUpController.signUpMessage.value, style: TextStyle(color: Colors.red))),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Color.fromARGB(255, 228, 184, 168)),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 228, 184, 168))),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 228, 184, 168), width: 2)),
      ),
    );
  }
}
