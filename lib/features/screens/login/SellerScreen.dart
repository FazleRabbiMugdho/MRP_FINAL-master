import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SellerScreen extends StatefulWidget {
  const SellerScreen({super.key});
  @override
  _SellerScreenState createState() => _SellerScreenState();
}

class _SellerScreenState extends State<SellerScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController buyerIdController = TextEditingController();
  final TextEditingController productController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  String? sellerUniqueId;
  String? currentUserId;
  String? sellerName;

  List<String> locations = ['Dhaka', 'Chittagong', 'Khulna', 'Rajshahi', 'Sylhet'];
  String selectedLocation = 'Dhaka';

  @override
  void initState() {
    super.initState();
    _fetchMerchantInfo();
  }

  Future<void> _fetchMerchantInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() => currentUserId = user.uid);

      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          sellerUniqueId = userDoc['unique_id'] ?? 'N/A';
          sellerName = userDoc['full_name'] ?? 'N/A';
        });
      }
    }
  }

  Future<void> _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      if (sellerUniqueId == null) {
        Get.snackbar('Error', 'Seller ID not found. Please try again.', backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      try {
        await FirebaseFirestore.instance.collection('buyer_notifications').add({
          'buyerId': buyerIdController.text,
          'sellerId': sellerUniqueId,
          'sellerName': sellerName,
          'product': productController.text,
          'quantity': int.parse(quantityController.text),
          'price': double.parse(priceController.text),
          'location': selectedLocation,
          'status': 'pending',
          'message': 'New product request from seller',
          'timestamp': FieldValue.serverTimestamp(),
        });

        buyerIdController.clear();
        productController.clear();
        quantityController.clear();
        priceController.clear();
        setState(() {
          selectedLocation = 'Dhaka';
        });

        Get.snackbar('Success', 'Request submitted successfully!', backgroundColor: Colors.green, colorText: Colors.white);
      } catch (e) {
        Get.snackbar('Error', 'Failed to submit request: $e', backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sell Product'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(buyerIdController, 'Buyer ID', Icons.person),
                const SizedBox(height: 16),
                _buildTextField(productController, 'Product', Icons.shopping_cart),
                const SizedBox(height: 16),
                _buildTextField(quantityController, 'Quantity', Icons.production_quantity_limits, isNumber: true),
                const SizedBox(height: 16),
                _buildTextField(priceController, 'Price', Icons.attach_money, isNumber: true),
                const SizedBox(height: 16),
                _buildDropdown(),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitRequest,
                  child: const Text('Send Request to Buyer'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
      ),
      validator: (value) => value!.isEmpty ? '$label is required' : null,
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedLocation,
      onChanged: (value) {
        setState(() {
          selectedLocation = value!;
        });
      },
      items: locations.map((location) {
        return DropdownMenuItem(value: location, child: Text(location));
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Select Location',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}