import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var confirmPassword = ''.obs;
  var fullName = ''.obs;
  var selectedRole = 'Administrator'.obs;
  var selectedLocation = 'Dhaka'.obs;
  var phoneNumber = ''.obs;
  var uniqueId = ''.obs;

  List<String> roles = ['Administrator', 'Merchant'];
  List<String> locations = ['Dhaka', 'Chattogram', 'Khulna', 'Rajshahi', 'Barishal', 'Sylhet', 'Rangpur'];

  Future<void> signUp() async {
    if (password.value != confirmPassword.value) {
      Get.snackbar('Error', 'Passwords do not match!');
      return;
    }

    if (fullName.value.isEmpty || email.value.isEmpty || phoneNumber.value.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields!');
      return;
    }

    // Check if the phone number is unique
    bool isUnique = await isPhoneNumberUnique(phoneNumber.value);
    if (!isUnique) {
      Get.snackbar('Error', 'Phone number already in use!');
      return;
    }

    // Generate unique ID before saving (set as phone number)
    generateUniqueId();

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.value,
        password: password.value,
      );

      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'full_name': fullName.value,
        'email': email.value,
        'role': selectedRole.value,
        'location': selectedLocation.value,
        'phone_number': phoneNumber.value,
        'unique_id': uniqueId.value,  // Unique ID is the phone number
      });

      Get.snackbar('Success', 'Sign Up Successful!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to sign up: $e');
    }
  }

  // Function to check if phone number is unique
  Future<bool> isPhoneNumberUnique(String phone) async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('phone_number', isEqualTo: phone)
        .get();

    return querySnapshot.docs.isEmpty; // Returns true if no matching phone number is found
  }

  void generateUniqueId() {
    uniqueId.value = phoneNumber.value;
  }
}
