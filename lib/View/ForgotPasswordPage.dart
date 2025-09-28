
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  void sendVerificationCode(BuildContext context) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Verification code sent!"), backgroundColor: Colors.green),
    );

    Navigator.push(context, MaterialPageRoute(builder: (context) => CodeVerificationPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 200, 190),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 235, 200, 190),
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            SizedBox(height: 50),
            Icon(Icons.email, color: Colors.white, size: 100),
            SizedBox(height: 20),
            Text("Enter Your Email", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              ),
            ),
            SizedBox(height: 20),
            MaterialButton(
              onPressed: () => sendVerificationCode(context),
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              child: Text("Send Code", style: TextStyle(color: const Color.fromARGB(255, 235, 200, 190), fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

class CodeVerificationPage extends StatelessWidget {
  final List<TextEditingController> controllers = List.generate(6, (_) => TextEditingController());

  void confirmCode(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Code Verified!"), backgroundColor: Colors.green),
    );

    Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordResetPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 200, 190),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 235, 200, 190),
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            SizedBox(height: 50),
            Icon(Icons.lock, color: Colors.white, size: 100),
            SizedBox(height: 20),
            Text("Enter Verification Code", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                6,
                (index) => SizedBox(
                  width: 40,
                  child: TextField(
                    controller: controllers[index],
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      counterText: "",
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            MaterialButton(
              onPressed: () => confirmCode(context),
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              child: Text("Confirm Code", style: TextStyle(color: const Color.fromARGB(255, 235, 200, 190), fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

class PasswordResetPage extends StatelessWidget {
  final TextEditingController passwordController = TextEditingController();

  void resetPassword(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Password Reset Successful!"), backgroundColor: Colors.green),
    );

    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 200, 190),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 235, 200, 190),
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            SizedBox(height: 50),
            Icon(Icons.vpn_key, color: Colors.white, size: 100),
            SizedBox(height: 20),
            Text("Enter New Password", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "New Password",
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              ),
            ),
            SizedBox(height: 20),
            MaterialButton(
              onPressed: () => resetPassword(context),
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              child: Text("Reset Password", style: TextStyle(color: const Color.fromARGB(255, 235, 200, 190), fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
