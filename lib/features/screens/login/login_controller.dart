import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'AdminScreen.dart'; // Ensure this import is correct
import 'BuyerAndSeller.dart'; // Ensure this import is correct

class LoginController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;

  Future<void> login() async {
    try {
      if (email.value.isEmpty || password.value.isEmpty) {
        Get.snackbar('Error', 'Please fill in both email and password');
        return;
      }

      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.value,
        password: password.value,
      );

      if (userCredential.user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (!userDoc.exists) {
          Get.snackbar('Error', 'User data not found');
          return;
        }

        String role = userDoc['role'] ?? '';

        if (role == 'Administrator') {
          Get.offAll(() => AdminScreen());
        } else if (role == 'Merchant') {
          Get.offAll(() => Buyerandseller());
        } else {
          Get.snackbar('Error', 'Invalid role');
        }
      } else {
        Get.snackbar('Error', 'Failed to log in');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error: $e');
    }
  }
}