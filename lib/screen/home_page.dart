import 'package:flutter/material.dart';
import 'loging.dart';
import 'signup.dart';

class HomePage extends StatelessWidget {
  final baseColor = const Color.fromARGB(255, 226, 176, 158);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildTopImage(),
            SizedBox(height: 16),
            _buildWelcomeText(),
            _buildWelcomeMessage(),
            SizedBox(height: 12), // ← بدل Spacer() رفعنا الأزرار قليلاً
            _buildButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTopImage() {
    return Container(
      width: double.infinity,
      height: 350,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/b2.png"),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Text(
      "WELCOME",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 32,
        color: Colors.black,
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 6),
      child: Text(
        "Welcome to our restaurant! Enjoy your meal",
        style: TextStyle(
          color: Colors.grey.shade700,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MaterialButton(
            minWidth: double.infinity,
            height: 60,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
            },
            color: baseColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              "Log In",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text("OR", style: TextStyle(fontSize: 16, color: Colors.black54)),
          SizedBox(height: 10),
          MaterialButton(
            minWidth: double.infinity,
            height: 60,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => SignUpPage()));
            },
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
              side: BorderSide(color: baseColor),
            ),
            child: Text(
              "Sign Up",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: baseColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
