import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mrp_phone/features/screens/profile/settings/account_information_screen.dart';
import 'package:mrp_phone/features/screens/profile/settings/account_security_screen.dart';
import 'package:mrp_phone/features/screens/profile/settings/helpSupport_screen.dart';
import 'package:mrp_phone/features/screens/profile/settings/notification_screen.dart';
import 'package:mrp_phone/features/screens/profile/settings/theme_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(LineAwesomeIcons.angle_left_solid, color: theme.colorScheme.onPrimary),
        ),
        title: Text(
          "Settings",
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 4,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [theme.colorScheme.background, theme.colorScheme.surface],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Account Settings Section
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(LineAwesomeIcons.user_cog_solid, color: theme.colorScheme.primary),
                        const SizedBox(width: 10),
                        Text(
                          "Account Settings",
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onBackground,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildSettingsItem(
                      context: context,
                      icon: LineAwesomeIcons.info_circle_solid,
                      title: "Account Information",
                      onTap: () {
                        Get.to(() => const AccountInformationScreen());
                      },
                    ),
                    _buildSettingsItem(
                      context: context,
                      icon: LineAwesomeIcons.shield_alt_solid,
                      title: "Account Security",
                      onTap: () {
                        Get.to(() => const AccountSecurityScreen());
                      },
                    ),
                    _buildSettingsItem(
                      context: context,
                      icon: LineAwesomeIcons.bell,
                      title: "Notifications",
                      onTap: () {
                        Get.to(() => const NotificationsScreen());
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // App Settings Section
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(LineAwesomeIcons.cog_solid, color: theme.colorScheme.primary),
                        const SizedBox(width: 10),
                        Text(
                          "App Settings",
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onBackground,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Dark Mode Toggle
                    Obx(() => ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Icon(LineAwesomeIcons.moon, color: theme.colorScheme.onPrimary, size: 20),
                      ),
                      title: Text(
                        "Dark Mode",
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onBackground,
                        ),
                      ),
                      trailing: Switch(
                        value: themeController.isDarkMode.value,
                        onChanged: (value) {
                          themeController.toggleTheme();
                        },
                        activeColor: theme.colorScheme.primary,
                      ),
                    )),
                    _buildSettingsItem(
                      context: context,
                      icon: LineAwesomeIcons.language_solid,
                      title: "Help & Support",
                      onTap: () {
                        Get.to(() => const HelpSupportScreen());
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    var theme = Theme.of(context);

    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Icon(icon, color: theme.colorScheme.onPrimary, size: 20),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: theme.colorScheme.onBackground,
        ),
      ),
      trailing: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.colorScheme.surfaceVariant.withOpacity(0.2),
        ),
        child: Icon(
          LineAwesomeIcons.angle_right_solid,
          size: 18.0,
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
      onTap: onTap,
    );
  }
}