import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class InformationScreen extends StatelessWidget {
  const InformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App Information", style: TextStyle(color: Colors.white)),
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
              const Center(
                child: Icon(LineAwesomeIcons.info_circle_solid, size: 100, color: Colors.blue),
              ),
              const SizedBox(height: 20),

              const Text(
                "About This App",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "This is a profile management app built with Flutter and GetX. It helps users manage their accounts, settings, and more.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),

              const Text(
                "Version",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text("1.0.0", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 20),

              const Text(
                "Developed By",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text("Mahim Abdullah Rianto - 20230104015", style: TextStyle(fontSize: 16)),
              const Text("Partha Sharathi Saha - 20230104017", style: TextStyle(fontSize: 16)),
              const Text("Fazle Rabbie Mugdho - 20230104002", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 40),

              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    print("Checking for updates...");
                  },
                  icon: const Icon(LineAwesomeIcons.cloud_download_alt_solid),
                  label: const Text("Check for Updates"),
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
}
