import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../profile/profile_screen.dart';
import 'package:mrp_phone/features/home_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  String adminFullName = '';
  String adminUniqueId = '';
  String currentUserId = '';
  String adminLocation= '';

  @override
  void initState() {
    super.initState();
    _fetchAdminInfo();
  }

  Future<void> _fetchAdminInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() => currentUserId = user.uid);
      DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          adminFullName = userDoc['full_name'] ?? 'Admin';
          adminUniqueId = userDoc['unique_id'] ?? 'N/A';
          adminLocation = userDoc['location'] ?? 'N/A';
        });
      }
    }
  }

  Stream<QuerySnapshot> _getFilteredTransactions() {
    Query query = FirebaseFirestore.instance.collection('transactions');
    if (searchQuery.isNotEmpty) {
      query = query.where('location', isEqualTo: adminLocation)
          .where('sellerId', isEqualTo: searchQuery)
          .where('buyerId', isEqualTo: searchQuery);
    } else {
      query = query.where('location', isEqualTo: adminLocation);
    }
    return query.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              if (result == 'profile') {
                Get.to(() => const ProfileScreen());
              } else if (result == 'logout') {
                _logout();
              } else if (result == 'product_list') {
                Get.to(() => HomeScreen());
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
              const PopupMenuItem<String>(
                value: 'product_list',
                child: Text('Product List'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Admin: $adminFullName',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Unique ID: $adminUniqueId',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                if (adminUniqueId == adminUniqueId)
                  SizedBox(
                    width: 250,
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        labelText: 'Search Merchant ID',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onChanged: (value) => setState(() => searchQuery = value),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getFilteredTransactions(),
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
                        child: ListTile(
                          leading: const Icon(Icons.shopping_cart),
                          title: Text('Product: ${data['product']}'),
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
          ],
        ),
      ),
    );
  }
}

Future<void> _logout() async {
  await FirebaseAuth.instance.signOut();
  Get.offAll(() => HomeScreen());
}
