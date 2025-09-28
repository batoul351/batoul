import 'package:flutter/material.dart';
import '../../Controller/home_controller.dart';

class HomePage extends StatelessWidget {
  final baseColor = const Color.fromARGB(255, 226, 176, 158);
  final HomeController controller = HomeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildTopImage(),
            const SizedBox(height: 16),
            _buildWelcomeText(),
            _buildWelcomeMessage(),
            const SizedBox(height: 12),
            controller.buildButtons(context, baseColor),
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
        image: const DecorationImage(
          image: AssetImage("assets/b2.png"),
          fit: BoxFit.cover,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: const [
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
    return const Text(
      "WELCOME",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 32,
        color: Colors.black,
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 6),
      child: Text(
        "Welcome to our restaurant! Enjoy your meal",
        style: TextStyle(
          color: Colors.black54,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
