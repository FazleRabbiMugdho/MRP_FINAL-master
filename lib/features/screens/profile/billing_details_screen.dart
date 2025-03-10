import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class BillingDetailsScreen extends StatelessWidget {
  const BillingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Billing Details", style: TextStyle(color: Colors.white)),
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
              // Payment Methods
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
                        "Payment Methods",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ListTile(
                        leading: const Icon(LineAwesomeIcons.credit_card, color: Colors.blue),
                        title: const Text("Visa **** 1234"),
                        subtitle: const Text("Expires 12/26"),
                        trailing: const Icon(Icons.edit, color: Colors.blue),
                        onTap: () {
                          print("Edit Card Details");
                        },
                      ),
                      ListTile(
                        leading: const Icon(LineAwesomeIcons.paypal, color: Colors.blue),
                        title: const Text("PayPal"),
                        subtitle: const Text("john.doe@example.com"),
                        trailing: const Icon(Icons.edit, color: Colors.blue),
                        onTap: () {
                          print("Edit PayPal Details");
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Billing History
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
                        "Billing History",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ListTile(
                        leading: const Icon(LineAwesomeIcons.file_invoice_solid, color: Colors.blue),
                        title: const Text("Invoice #123456"),
                        subtitle: const Text("Paid - Jan 10, 2025"),
                        trailing: const Icon(Icons.download, color: Colors.blue),
                        onTap: () {
                          print("Download Invoice");
                        },
                      ),
                      ListTile(
                        leading: const Icon(LineAwesomeIcons.file_invoice_solid, color: Colors.blue),
                        title: const Text("Invoice #123457"),
                        subtitle: const Text("Pending - Feb 10, 2025"),
                        trailing: const Icon(Icons.download, color: Colors.blue),
                        onTap: () {
                          print("Download Invoice");
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Add Payment Method
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    print("Add Payment Method");
                  },
                  icon: const Icon(LineAwesomeIcons.plus_circle_solid),
                  label: const Text("Add Payment Method"),
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
