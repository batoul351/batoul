import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api_service/api_profile.dart';

const Color accentColor = Color.fromARGB(255, 228, 184, 168);
const Color backgroundTop = Color(0xFFF9F5F3);
const Color backgroundBottom = Color(0xFFEAD2C2);
const Color fieldFillColor = Color(0xFFF9F5F3);

class ProfileScreen extends StatelessWidget {
  final controller = Get.put(ProfileController());

  InputDecoration buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: accentColor),
      prefixIcon: Icon(icon, color: accentColor),
      filled: true,
      fillColor: fieldFillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: accentColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: accentColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: accentColor, width: 2),
      ),
    );
  }

  Widget profileCard() {
    return Center(
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 600),
        opacity: 1,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: accentColor, width: 3),
                  ),
                  child: CircleAvatar(
                    radius: 75,
                    backgroundImage: controller.imagePath.value.isNotEmpty
                        ? NetworkImage(controller.imagePath.value)
                        : const AssetImage('assets/default_avatar.png') as ImageProvider,
                  ),
                ),
                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('City:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(controller.cityController.text, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 16),
                    const Text('Street:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(controller.streetController.text, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 16),
                    const Text('Phone Number:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.phone, size: 18, color: accentColor),
                        const SizedBox(width: 8),
                        Text(controller.phoneController.text, style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget profileForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() {
              return controller.imageFile.value != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        controller.imageFile.value!,
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Text('No image selected');
            }),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: controller.pickImage,
              icon: const Icon(Icons.image),
              label: const Text('Choose Image'),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: controller.cityController,
              decoration: buildInputDecoration('City', Icons.location_city),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.streetController,
              decoration: buildInputDecoration('Street', Icons.location_on),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.phoneController,
              decoration: buildInputDecoration('Phone Number', Icons.phone),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: controller.submitProfile,
              icon: const Icon(Icons.save),
              label: const Text('Submit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [backgroundTop, backgroundBottom],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Obx(() {
          return controller.hasProfile.value ? profileCard() : profileForm();
        }),
      ),
      appBar: AppBar(
        backgroundColor: accentColor,
        title: const Text('User Profile'),
        centerTitle: true,
        elevation: 2,
      ),
    );
  }
}
