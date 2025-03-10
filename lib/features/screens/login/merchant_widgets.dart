import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'BuyerScreen.dart';
import 'SellerScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Buyerandseller extends StatefulWidget {
  const Buyerandseller({super.key});

  @override
  _BuyerandsellerState createState() => _BuyerandsellerState();
}

class _BuyerandsellerState extends State<Buyerandseller> {
  String userRole = '';
  String userName = '';
  String userUniqueId = '';

  @override
  void initState() {
    super.initState();
    _fetchUserRole();
  }

  Future<void> _fetchUserRole() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var docSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (docSnapshot.exists) {
        setState(() {
          userRole = docSnapshot['role'];
          userName = docSnapshot['fullName'];
          userUniqueId = docSnapshot['uniqueId'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Merchant Dashboard'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Profile Section (without image)
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey, // Placeholder for profile image
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              userName.isNotEmpty ? 'Welcome, $userName!' : 'Loading...',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              'Unique ID: $userUniqueId',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),

            // Access Buyer and Seller screens
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.shopping_cart, color: Colors.blue),
                title: const Text('Access Buyer Screen', style: TextStyle(fontSize: 18)),
                onTap: () {
                  Get.to(() => BuyerScreen());
                },
              ),
            ),
            const SizedBox(height: 20),

            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.storefront, color: Colors.green),
                title: const Text('Access Seller Screen', style: TextStyle(fontSize: 18)),
                onTap: () {
                  Get.to(() => const SellerScreen()); // Navigate to Sell Product screen
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
