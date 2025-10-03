import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  final controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = theme.primaryColor;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final cardColor = theme.cardColor;
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.black;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: accentColor,
        title: Text('User Profile', style: theme.textTheme.titleLarge?.copyWith(color: Colors.white)),
        centerTitle: true,
        elevation: 2,
      ),
      body: Container(
        color: backgroundColor,
        child: Obx(() {
          return controller.hasProfile.value
              ? _buildProfileCard(context)
              : _buildProfileForm(context);
        }),
      ),
    );
  }

  InputDecoration buildInputDecoration(BuildContext context, String label, IconData icon) {
    final theme = Theme.of(context);
    final accentColor = theme.primaryColor;
    final fillColor = theme.cardColor;

    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: accentColor),
      prefixIcon: Icon(icon, color: accentColor),
      filled: true,
      fillColor: fillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: accentColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: accentColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: accentColor, width: 2),
      ),
    );
  }

  Widget _buildProfileForm(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = theme.primaryColor;

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
                  : Text('No image selected', style: theme.textTheme.bodyMedium);
            }),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: controller.pickImage,
              icon: const Icon(Icons.image),
              label: const Text('Choose Image'),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: controller.cityController,
              decoration: buildInputDecoration(context, 'City', Icons.location_city),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.streetController,
              decoration: buildInputDecoration(context, 'Street', Icons.location_on),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.phoneController,
              decoration: buildInputDecoration(context, 'Phone Number', Icons.phone),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: controller.submitProfile,
              icon: const Icon(Icons.save),
              label: const Text('Submit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = theme.primaryColor;
    final cardColor = theme.cardColor;
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.black;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          decoration: BoxDecoration(
            color: cardColor,
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
                  backgroundImage: controller.imageFile.value != null
                      ? FileImage(controller.imageFile.value!)
                      : controller.imagePath.value.isNotEmpty
                          ? NetworkImage(controller.imagePath.value)
                          : const AssetImage('assets/default_avatar.png') as ImageProvider,
                ),
              ),
              const SizedBox(height: 24),
              _infoRow(context, 'City:', controller.cityController.text),
              _infoRow(context, 'Street:', controller.streetController.text),
              _infoRow(context, 'Phone Number:', controller.phoneController.text, icon: Icons.phone),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(BuildContext context, String label, String value, {IconData? icon}) {
    final theme = Theme.of(context);
    final accentColor = theme.primaryColor;
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.black;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          if (icon != null) Icon(icon, size: 18, color: accentColor),
          if (icon != null) const SizedBox(width: 8),
          Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: TextStyle(fontSize: 16, color: textColor))),
        ],
      ),
    );
  }
}
