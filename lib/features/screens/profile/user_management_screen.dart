import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Management", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(LineAwesomeIcons.angle_left_solid, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade700, Colors.blue.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 4, // Subtle shadow
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Manage Users
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Manage Users",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView(
                          children: [
                            userTile("John Doe", "Admin", "assets/images/profile.png"),
                            userTile("Alice Smith", "Editor", "assets/images/profile.png"),
                            userTile("Michael Johnson", "Viewer", "assets/images/profile.png"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Add User Button
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    print("Add New User");
                  },
                  icon: const Icon(LineAwesomeIcons.user_plus_solid),
                  label: const Text("Add New User"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget userTile(String name, String role, String imagePath) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(imagePath),
      ),
      title: Text(name),
      subtitle: Text(role),
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          if (value == "Edit") {
            print("Edit User: $name");
          } else if (value == "Remove") {
            print("Remove User: $name");
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(value: "Edit", child: Text("Edit User")),
          const PopupMenuItem(value: "Remove", child: Text("Remove User", style: TextStyle(color: Colors.red))),
        ],
        icon: const Icon(LineAwesomeIcons.ellipsis_v_solid),
      ),
    );
  }
}
