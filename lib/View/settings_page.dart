import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../Controller/theme_controller.dart';
import '../Service/logout_service.dart';
import 'login_page.dart';
import 'profile_page.dart';

class SettingsPage extends StatelessWidget {
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = theme.primaryColor;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.black;

    return Obx(() {
      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: accentColor,
          title: Text("Settings", style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 10),

            ListTile(
              leading: Icon(Icons.person, color: accentColor),
              title: Text("Profile", style: TextStyle(color: textColor)),
              subtitle: Text("View and edit your profile", style: TextStyle(color: textColor.withOpacity(0.6))),
              onTap: () => Get.to(() => ProfileScreen()),
            ),

            const Divider(),

            SwitchListTile(
              title: Text("Dark Mode", style: TextStyle(color: textColor)),
              subtitle: Text("Switch between light and dark mode", style: TextStyle(color: textColor.withOpacity(0.6))),
              value: themeController.isDark.value,
              onChanged: (val) => themeController.toggleTheme(),
              activeColor: accentColor,
            ),

            const Divider(),

            ListTile(
              leading: Icon(Icons.refresh, color: accentColor),
              title: Text("Reset Theme", style: TextStyle(color: textColor)),
              subtitle: Text("Restore default colors and mode", style: TextStyle(color: textColor.withOpacity(0.6))),
              onTap: () => themeController.resetTheme(),
            ),

            const Divider(),

            ListTile(
              leading: Icon(Icons.logout, color: accentColor),
              title: Text("Logout", style: TextStyle(color: textColor)),
              subtitle: Text("Sign out from your account", style: TextStyle(color: textColor.withOpacity(0.6))),
              onTap: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Confirm Logout"),
                    content: Text("Are you sure you want to log out?"),
                    actions: [
                      TextButton(
                        child: Text("Cancel"),
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                      TextButton(
                        child: Text("Logout"),
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                    ],
                  ),
                );

                if (confirmed == true) {
                  final success = await LogoutService().logout();
                  if (success) {
                    Get.offAll(() => LoginPage());
                  } else {
                    Get.snackbar("Error", "Logout failed. Please try again.",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                }
              },
            ),
          ],
        ),
      );
    });
  }
}
