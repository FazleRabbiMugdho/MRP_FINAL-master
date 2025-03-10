import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mrp_phone/features/screens/profile/profile_menu.dart';
import 'package:mrp_phone/features/screens/profile/setting_page.dart';
import 'package:mrp_phone/features/screens/profile/update_profile_screen.dart';
import 'package:mrp_phone/features/screens/profile/user_management_screen.dart';
import '../../../src/constants/sizes.dart';
import 'billing_details_screen.dart';
import 'information_screen.dart';
import 'logOutPage.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(LineAwesomeIcons.angle_left_solid, color: theme.colorScheme.onPrimary),
        ),
        title: Text(
          "Profile",
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              // Default User Icon instead of Profile Picture
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary.withOpacity(0.2),
                ),
                child: Icon(
                  LineAwesomeIcons.user_circle_solid, // User icon
                  size: 80,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 10),

              // Name
              Text(
                "Welcome To",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 5),

              // Subheading
              Text(
                "Market Rate Price",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 20),

              // Edit Profile Button
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => Get.to(() => UpdateProfileScreen()),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: const StadiumBorder(),
                    shadowColor: theme.colorScheme.primary.withOpacity(0.3),
                    elevation: 5,
                    backgroundColor: Colors.transparent,
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Edit Profile",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Menu Items
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      ProfileMenuWidget(
                        title: "Settings",
                        icon: LineAwesomeIcons.cog_solid,
                        onPress: () => Get.to(() => const SettingsScreen()),
                      ),
                      ProfileMenuWidget(
                        title: "Billing Details",
                        icon: LineAwesomeIcons.wallet_solid,
                        onPress: () => Get.to(() => const BillingDetailsScreen()),
                      ),
                      ProfileMenuWidget(
                        title: "User Management",
                        icon: LineAwesomeIcons.user_check_solid,
                        onPress: () => Get.to(() => const UserManagementScreen()),
                      ),
                      const Divider(),
                      const SizedBox(height: 10),
                      ProfileMenuWidget(
                        title: "Information",
                        icon: LineAwesomeIcons.info_solid,
                        onPress: () => Get.to(() => const InformationScreen()),
                      ),
                      ProfileMenuWidget(
                        title: "Logout",
                        icon: LineAwesomeIcons.sign_out_alt_solid,
                        textColor: Colors.red,
                        endIcon: false,
                        onPress: () {
                          Get.defaultDialog(
                            title: "Logout",
                            middleText: "Are you sure you want to logout?",
                            textConfirm: "Yes",
                            textCancel: "No",
                            confirmTextColor: Colors.white,
                            onConfirm: () {
                              Get.to(() => const LogoutPage());
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}













/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mrp_phone/features/screens/profile/profile_menu.dart';
import 'package:mrp_phone/features/screens/profile/setting_page.dart';
import 'package:mrp_phone/features/screens/profile/update_profile_screen.dart';
import 'package:mrp_phone/features/screens/profile/user_management_screen.dart';
import '../../../src/constants/sizes.dart';
import 'billing_details_screen.dart';
import 'information_screen.dart';
import 'logOutPage.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(LineAwesomeIcons.angle_left_solid, color: theme.colorScheme.onPrimary),
        ),
        title: Text(
          "Profile",
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              // Profile Picture
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: const Image(
                        image: AssetImage("assets/images/profile/profile.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(LineAwesomeIcons.pencil_alt_solid, size: 20.0, color: theme.colorScheme.onPrimary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Name
              Text(
                "Welcome To",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 5),
              // Subheading
              Text(
                "Market Rate Price",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 20),
              // Edit Profile Button
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => Get.to(() =>  UpdateProfileScreen()),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: const StadiumBorder(),
                    shadowColor: theme.colorScheme.primary.withOpacity(0.3),
                    elevation: 5,
                    backgroundColor: Colors.transparent,
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Edit Profile",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Menu Items
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      ProfileMenuWidget(
                        title: "Settings",
                        icon: LineAwesomeIcons.cog_solid,
                        onPress: () => Get.to(() => const SettingsScreen()),
                      ),
                      ProfileMenuWidget(
                        title: "Billing Details",
                        icon: LineAwesomeIcons.wallet_solid,
                        onPress: () => Get.to(() => const BillingDetailsScreen()),
                      ),
                      ProfileMenuWidget(
                        title: "User Management",
                        icon: LineAwesomeIcons.user_check_solid,
                        onPress: () => Get.to(() => const UserManagementScreen()),
                      ),
                      const Divider(),
                      const SizedBox(height: 10),
                      ProfileMenuWidget(
                        title: "Information",
                        icon: LineAwesomeIcons.info_solid,
                        onPress: () => Get.to(() => const InformationScreen()),
                      ),
                      ProfileMenuWidget(
                        title: "Logout",
                        icon: LineAwesomeIcons.sign_out_alt_solid,
                        textColor: Colors.red,
                        endIcon: false,
                        onPress: () {
                          Get.defaultDialog(
                            title: "Logout",
                            middleText: "Are you sure you want to logout?",
                            textConfirm: "Yes",
                            textCancel: "No",
                            confirmTextColor: Colors.white,
                            onConfirm: () {
                              Get.to(() => const LogoutPage());
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/