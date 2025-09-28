import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/profile_controller.dart';

const Color accentColor = Color.fromARGB(255, 228, 184, 168);
const Color backgroundTop = Color(0xFFF9F5F3);
const Color backgroundBottom = Color(0xFFEAD2C2);
const Color fieldFillColor = Color(0xFFF9F5F3);

class ProfilePage extends StatelessWidget {
  final controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: accentColor,
        title: const Text('User Profile'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [backgroundTop, backgroundBottom],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Obx(() {
          return controller.hasProfile.value
              ? _buildProfileCard()
              : _buildProfileForm();
        }),
      ),
    );
  }

  Widget _buildProfileForm() {
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
            _buildTextField('City', Icons.location_city, controller.cityController),
            const SizedBox(height: 16),
            _buildTextField('Street', Icons.location_on, controller.streetController),
            const SizedBox(height: 16),
            _buildTextField('Phone Number', Icons.phone, controller.phoneController, isPhone: true),
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

  Widget _buildProfileCard() {
    return Center(
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
              _buildInfoRow('City:', controller.cityController.text),
              _buildInfoRow('Street:', controller.streetController.text),
              _buildInfoRow('Phone Number:', controller.phoneController.text, icon: Icons.phone),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, TextEditingController controller, {bool isPhone = false}) {
    return TextField(
      controller: controller,
      keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
      decoration: InputDecoration(
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
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          if (icon != null) Icon(icon, size: 18, color: accentColor),
          if (icon != null) const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
