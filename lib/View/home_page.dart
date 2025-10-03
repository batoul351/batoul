import 'package:flutter/material.dart';
import '../../Controller/home_controller.dart';

class HomePage extends StatelessWidget {
  final HomeController controller = HomeController();

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).primaryColor;
    final textColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopImage(),
            const SizedBox(height: 16),
            _buildWelcomeText(context),
            _buildWelcomeMessage(context),
            const SizedBox(height: 12),
            controller.buildButtons(context, accentColor),
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

  Widget _buildWelcomeText(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge ??
        const TextStyle(fontSize: 32, fontWeight: FontWeight.bold);

    return Text(
      "WELCOME",
      style: titleStyle.copyWith(fontSize: 32),
    );
  }

  Widget _buildWelcomeMessage(BuildContext context) {
    final bodyStyle = Theme.of(context).textTheme.bodyMedium ??
        const TextStyle(fontSize: 16);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 6),
      child: Text(
        "Welcome to our restaurant! Enjoy your meal",
        style: bodyStyle.copyWith(fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }
}
