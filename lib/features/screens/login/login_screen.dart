import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../signUp/sign_up_screen.dart';
import 'login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loginController = Get.put(LoginController());
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLoginHeader(context, size),
                const SizedBox(height: 40),
                _buildTextField(
                    label: 'Email',
                    onChanged: (value) => loginController.email.value = value,
                    icon: Icons.email),
                _buildTextField(
                    label: 'Password',
                    onChanged: (value) => loginController.password.value = value,
                    obscureText: true,
                    icon: Icons.lock),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () {
                    loginController.login();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 30),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 10,
                    shadowColor: Colors.blueAccent,
                  ),
                  icon: const Icon(Icons.login, size: 24),
                  label: const Text('Login', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Get.to(() => const SignUpScreen());
                  },
                  child: const Text("Don't have an account? Sign Up", style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginHeader(BuildContext context, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          'assets/images/welcomePage_images/welcome_screen_image.png', // Ensure this image exists in assets
          height: size.height * 0.2,
        ),
        const SizedBox(height: 20),
        Text(
          'Welcome Back!',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Please log in to continue.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required Function(String) onChanged,
    bool obscureText = false,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        onChanged: onChanged,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.blue.shade700),
          prefixIcon: Icon(icon, color: Colors.blue.shade700),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
            borderRadius: BorderRadius.circular(15),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
    );
  }
}