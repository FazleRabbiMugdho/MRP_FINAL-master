import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mrp_phone/features/screens/login/login_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  var selectedLocation = "Barishal".obs;
  var searchQuery = "".obs;
  var selectedComplainLocation = "Barishal".obs;
  var complainNumber = "".obs;

  final Map<String, String> complainNumbers = {
    "Barishal": "01720298448",
    "Chittagong": "01609302952",
    "Dhaka": "01780803694",
    "Khulna": "01720298333",
    "Mymensingh": "01720298567",
    "Rajshahi": "01720298928",
    "Rangpur": "01720298409",
    "Sylhet": "01720298423",
  };

  // Static list of products wrapped in RxList to observe changes
  var products = [
    {"name": "Egg", "price": "৳12 per piece", "image": "assets/images/home/egg.png", "description": "Fresh farm eggs, rich in protein."},
    {"name": "Mango", "price": "৳150 per kg", "image": "assets/images/home/mango.png", "description": "Juicy and sweet mangoes from the best farms."},
    {"name": "Milk", "price": "৳80 per liter", "image": "assets/images/home/milk.png", "description": "Fresh cow milk, rich in calcium."},
    {"name": "Chicken", "price": "৳250 per kg", "image": "assets/images/home/chicken.png", "description": "Fresh farm-raised chicken."},
    {"name": "Mutton", "price": "৳900 per kg", "image": "assets/images/home/mutton.png", "description": "Tender and high-quality mutton."},
    {"name": "Beef", "price": "৳700 per kg", "image": "assets/images/home/beef.png", "description": "Fresh beef, perfect for cooking."},
    {"name": "Carrot", "price": "৳40 per kg", "image": "assets/images/home/carrot.png", "description": "Fresh organic carrots."},
    {"name": "Tomato", "price": "৳30 per kg", "image": "assets/images/home/tomato.png", "description": "Juicy and ripe tomatoes."},
    {"name": "Potato", "price": "৳25 per kg", "image": "assets/images/home/potato.png", "description": "Farm-fresh potatoes."},
    {"name": "Rice", "price": "৳70 per kg", "image": "assets/images/home/rice.png", "description": "Organic."},
    {"name": "Oil", "price": "৳180 per liter", "image": "assets/images/home/oil.png", "description": "Organic & rich in protein."},
    {"name": "Dal", "price": "৳120 per kg", "image": "assets/images/home/dal.png", "description": "Organic."},
  ].obs;

  // Fetch new products from Firestore
  Future<List<Map<String, dynamic>>> fetchNewProducts() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('products').get();
    return snapshot.docs.map((doc) {
      return {
        "name": doc['name'],
        "price": doc['price'],
        "image": doc['image'],
        "description": doc['description'],
        "id": doc.id, // Add product ID for deletion reference
      };
    }).toList();
  }

  // Function to fetch saved prices from SharedPreferences
  Future<void> loadSavedPrices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var product in products) {
      String? savedPrice = prefs.getString(product["name"]!);
      if (savedPrice != null) {
        product["price"] = savedPrice;
      }
    }
  }

  // Save edited price to SharedPreferences and update the list
  Future<void> savePrice(int productIndex, String newPrice) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(products[productIndex]["name"]!, newPrice);  // Save in SharedPreferences
    products[productIndex]["price"] = newPrice; // Update the local list
  }

  // Check if the user is an admin
  Future<bool> isAdmin() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        return userDoc['role'] == 'Administrator'; // assuming the user has a 'role' field in Firestore
      }
      return false;
    } catch (e) {
      print("Error checking admin status: $e");
      return false;
    }
  }

  // Function to delete product from Firebase and local list
  Future<void> deleteProduct(String productId, int productIndex) async {
    // Delete product from Firebase Firestore
    await FirebaseFirestore.instance.collection('products').doc(productId).delete();

    // Remove product from local list
    products.removeAt(productIndex);
    products.refresh(); // Refresh the products list to update UI
  }

  // Function to show price edit dialog
  void showEditPriceDialog(BuildContext context, int productIndex) {
    TextEditingController priceController = TextEditingController(text: products[productIndex]["price"]);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Price"),
          content: TextField(
            controller: priceController,
            decoration: InputDecoration(hintText: "Enter new price"),
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: Text("Cancel")),
            TextButton(onPressed: () async {
              String newPrice = priceController.text;
              if (newPrice.isNotEmpty) {
                await savePrice(productIndex, newPrice);
                products.refresh();  // Refresh the products to instantly update the UI
                Get.back(); // Close dialog after saving
              }
            }, child: Text("Save")),
          ],
        );
      },
    );
  }

  // Function to show dialog for adding a new product
  void showAddProductDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController imageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add New Product"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(hintText: "Enter product name"),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(hintText: "Enter product price"),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(hintText: "Enter product description"),
              ),
              TextField(
                controller: imageController,
                decoration: InputDecoration(hintText: "Enter product image URL or asset path"),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: Text("Cancel")),
            TextButton(onPressed: () async {
              String name = nameController.text;
              String price = priceController.text;
              String description = descriptionController.text;
              String image = imageController.text;

              if (name.isNotEmpty && price.isNotEmpty && description.isNotEmpty && image.isNotEmpty) {
                // Add product to Firebase
                var productRef = await FirebaseFirestore.instance.collection('products').add({
                  'name': name,
                  'price': price,
                  'description': description,
                  'image': image,
                });

                // Add to the local products list
                products.add({
                  "name": name,
                  "price": price,
                  "image": image,
                  "description": description,
                  "id": productRef.id,
                });
                Get.back();
              }
            }, child: Text("Add")),
          ],
        );
      },
    );
  }

  // Complain location dialog
  void showComplainLocationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select Area for Complain"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() => DropdownButton<String>(
                value: selectedComplainLocation.value,
                onChanged: (newLocation) {
                  if (newLocation != null) {
                    selectedComplainLocation.value = newLocation;
                    complainNumber.value = complainNumbers[newLocation]!;
                  }
                },
                items: complainNumbers.keys.map<DropdownMenuItem<String>>((String location) {
                  return DropdownMenuItem<String>(value: location, child: Text(location));
                }).toList(),
              )),
              Obx(() {
                return Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    "Complain Number: ${complainNumber.value}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                );
              }),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: Text("Close")),
          ],
        );
      },
    );
  }

  // Build the HomeScreen UI
  @override
  Widget build(BuildContext context) {
    // Load saved product prices
    loadSavedPrices();

    return Scaffold(
      appBar: AppBar(
        title: const Text("M.R.P.", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.menu),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'login',
                child: const Text("Login/SignUp"),
                onTap: () => Get.to(() => const LoginScreen(), transition: Transition.rightToLeft),
              ),
              PopupMenuItem(
                value: 'dark_mode',
                child: Row(
                  children: [
                    Icon(Get.isDarkMode ? Icons.light_mode : Icons.dark_mode),
                    SizedBox(width: 10),
                    Text(Get.isDarkMode ? "Light Mode" : "Dark Mode"),
                  ],
                ),
                onTap: () {
                  // Toggle dark mode
                  Get.changeTheme(Get.isDarkMode ? ThemeData.light() : ThemeData.dark());
                },
              ),
              PopupMenuItem(
                value: 'complain',
                child: Row(
                  children: [
                    Icon(Icons.report),
                    SizedBox(width: 10),
                    Text("Report"),
                  ],
                ),
                onTap: () => showComplainLocationDialog(context),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              onChanged: (query) => searchQuery.value = query,
              decoration: InputDecoration(
                hintText: "Search products...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                final filteredProducts = products.where((product) {
                  return product["name"]!.toLowerCase().contains(searchQuery.value.toLowerCase());
                }).toList();

                return FutureBuilder<List<Map<String, dynamic>>>(

                  future: fetchNewProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text("Error fetching products"));
                    }

                    final newProducts = snapshot.data ?? [];
                    final allProducts = List.from(filteredProducts)..addAll(newProducts);

                    return FutureBuilder<bool>(

                      future: isAdmin(),
                      builder: (context, snapshot) {
                        bool isAdminUser = snapshot.data ?? false;

                        return LayoutBuilder(
                          builder: (context, constraints) {
                            int crossAxisCount = 2;
                            if (constraints.maxWidth > 600) {
                              crossAxisCount = 3;
                            } else if (constraints.maxWidth > 400) {
                              crossAxisCount = 2;
                            } else {
                              crossAxisCount = 1;
                            }

                            return GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                childAspectRatio: 0.6,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: allProducts.length,
                              itemBuilder: (context, index) {
                                final product = allProducts[index];
                                return Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                  elevation: 6,
                                  shadowColor: Colors.grey.withOpacity(0.3),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 150,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                                        ),
                                        child: product["image"]!.startsWith('https')
                                            ? Image.network(
                                          product["image"]!,
                                          fit: BoxFit.contain,
                                        )
                                            : Image.asset(
                                          product["image"]!,
                                          fit: BoxFit.contain,
                                        ),

                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              product["name"]!,
                                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              product["price"]!,
                                              style: TextStyle(fontSize: 16, color: Colors.green),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              product["description"]!,
                                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
                                              textAlign: TextAlign.center,
                                            ),
                                            if (isAdminUser)
                                              Column(
                                                children: [
                                                  TextButton(
                                                    onPressed: () => showEditPriceDialog(context, index),
                                                    child: Text("Edit Price"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      String productId = product["id"]!;
                                                      await deleteProduct(productId, index);
                                                      products.refresh();  // Refresh the products list after deletion
                                                    },
                                                    child: Text("Delete Product", style: TextStyle(color: Colors.red)),
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                );
              }),
            ),
            // Show "Add Product" button for Admin users
            FutureBuilder<bool>(

              future: isAdmin(),
              builder: (context, snapshot) {
                if (snapshot.data ?? false) {
                  return IconButton(
                    onPressed: () => showAddProductDialog(context),
                    icon: Icon(Icons.add_circle_outline, size: 50),
                  );
                }
                return SizedBox.shrink(); // Hide button for non-admin users
              },
            ),
          ],
        ),
      ),
    );
  }
}