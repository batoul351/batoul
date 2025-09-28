import 'package:flutter/material.dart';
import '../View/login_page.dart';
import '../../View/signup_page.dart';

class HomeController {
  Widget buildButtons(BuildContext context, Color baseColor) {
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
            child: const Text(
              "Log In",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text("OR", style: TextStyle(fontSize: 16, color: Colors.black54)),
          const SizedBox(height: 10),
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
