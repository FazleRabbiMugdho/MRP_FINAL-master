import 'package:flutter/material.dart';

class AccountSecurityScreen extends StatelessWidget {
  const AccountSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account Security"),
      ),
      body: const Center(
        child: Text("Account Security Screen"),
      ),
    );
  }
}