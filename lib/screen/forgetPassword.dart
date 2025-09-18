import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api_service/api_forgetbassword.dart';

class ResetPasswordUnifiedPage extends StatefulWidget {
  @override
  _ResetPasswordUnifiedPageState createState() => _ResetPasswordUnifiedPageState();
}

class _ResetPasswordUnifiedPageState extends State<ResetPasswordUnifiedPage> {
  final AuthService authService = AuthService();

  final TextEditingController tokenController = TextEditingController();
  final List<TextEditingController> codeControllers = List.generate(6, (_) => TextEditingController());
  final TextEditingController passwordController = TextEditingController();

  bool codeSent = false;

  void sendCode() async {
    final token = tokenController.text.trim();
    if (token.isEmpty) {
      Get.snackbar("تنبيه", "يرجى إدخال التوكن", backgroundColor: Colors.orange);
      return;
    }

    await authService.sendVerificationCode(token);
    setState(() {
      codeSent = true;
    });
  }

  void resetPassword() async {
    final token = tokenController.text.trim();
    final code = codeControllers.map((c) => c.text).join();
    final newPassword = passwordController.text.trim();

    if (code.length != 6 || newPassword.length < 6) {
      Get.snackbar("تنبيه", "يرجى إدخال كود مكون من 6 أرقام وكلمة مرور لا تقل عن 6 أحرف", backgroundColor: Colors.orange);
      return;
    }

    await authService.changePassword(token, code, newPassword);
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 200, 190),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 235, 200, 190),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Icon(Icons.email, color: Colors.white, size: 100),
              const SizedBox(height: 20),
              const Text("Enter Your Token", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 10),
              TextField(
                controller: tokenController,
                decoration: const InputDecoration(
                  labelText: "Token",
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
              if (!codeSent)
                MaterialButton(
                  onPressed: sendCode,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  child: const Text("Send Code", style: TextStyle(color: Color.fromARGB(255, 235, 200, 190), fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              if (codeSent) ...[
                const SizedBox(height: 30),
                const Icon(Icons.lock, color: Colors.white, size: 100),
                const SizedBox(height: 20),
                const Text("Enter Verification Code", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    6,
                    (index) => SizedBox(
                      width: 40,
                      child: TextField(
                        controller: codeControllers[index],
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          counterText: "",
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Icon(Icons.vpn_key, color: Colors.white, size: 100),
                const SizedBox(height: 20),
                const Text("Enter New Password", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "New Password",
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 20),
                MaterialButton(
                  onPressed: resetPassword,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  child: const Text("Reset Password", style: TextStyle(color: Color.fromARGB(255, 235, 200, 190), fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
