import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../home_screen.dart';
import '../profile/profile_screen.dart';
import 'login_screen.dart';
import 'BuyerScreen.dart';
import 'SellerScreen.dart';

class Buyerandseller extends StatefulWidget {
  const Buyerandseller({super.key});

  @override
  _BuyerandsellerState createState() => _BuyerandsellerState();
}

class _BuyerandsellerState extends State<Buyerandseller> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  String merchantFullName = '';
  String merchantUniqueId = '';
  String currentUserId = '';
  bool isMerchant = false;

  @override
  void initState() {
    super.initState();
    _fetchMerchantInfo();
  }

  Future<void> _fetchMerchantInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() => currentUserId = user.uid);
      DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          merchantFullName = userDoc['full_name'] ?? 'Merchant';
          merchantUniqueId = userDoc['unique_id'] ?? 'N/A';
          isMerchant = userDoc['role'] == 'merchant';
        });
      }
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAll(() =>  HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Merchant Dashboard'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              if (result == 'profile') {
                Get.to(() => const ProfileScreen());
              } else if (result == 'logout') {
                _logout();
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('Profile'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Merchant: $merchantFullName',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Unique ID: $merchantUniqueId',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),


            if (isMerchant)
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Search Seller ID',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) => setState(() => searchQuery = value),
              ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => BuyerScreen());
                  },
                  child: const Text('Buy Product'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    textStyle: const TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                // Sell Product Button
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => const SellerScreen());
                  },
                  child: const Text('Sell Product'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    textStyle: const TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('transactions')
                    .where('sellerId', isEqualTo: merchantUniqueId) // Filter by merchant ID
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No transactions found.'));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: Colors.white.withOpacity(0.8),
                        child: ListTile(
                          leading: const Icon(Icons.shopping_cart, color: Colors.blueAccent),
                          title: Text(
                            'Product: ${data['product']}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Buyer ID: ${data['buyerId'] ?? 'N/A'}\n'
                                'Seller ID: ${data['sellerId'] ?? 'N/A'}\n'
                                'Quantity: ${data['quantity']}\n'
                                'Price: \$${data['price'].toStringAsFixed(2)}',
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            // Warning Message at the Bottom
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                padding: const EdgeInsets.all(10),
                color: Colors.orangeAccent,
                child: const Text(
                  'Warning: Price manipulation through syndicates is illegal under the Bangladesh Competition Act,'
                      ' 2012. Such unethical practices disrupt fair competition and are punishable by fines and imprisonment.'
                      ' Authorities will act decisively against violators to ensure market fairness..',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
