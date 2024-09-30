import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/AuthController.dart';
import 'login_Screens.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  AuthController controller = Get.put(AuthController());

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              color: Colors.blue,
              child: Padding(
                padding: const EdgeInsets.only(top: 60, left: 20),
                child: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Sign Up\n',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      TextSpan(
                        text: 'Create your account!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 250),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height - 250,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 235,
              left: 0,
              right: 0,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      // Form Fields
                      _buildTextField(
                          controller.nameController, 'Name', Icons.text_format),
                      const SizedBox(height: 15),
                      _buildTextField(emailController, 'Email', Icons.email),
                      const SizedBox(height: 15),
                      _buildTextField(controller.addressController, 'Address',
                          Icons.location_city),
                      const SizedBox(height: 15),
                      _buildTextField(
                          controller.phoneController, 'Phone', Icons.phone,
                          keyboardType: TextInputType.number),
                      const SizedBox(height: 15),
                      _buildTextField(passController, 'Password', Icons.lock,
                          isPassword: true),
                      const SizedBox(height: 40),

                      // Sign Up button
                      Container(
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          gradient: const LinearGradient(
                            colors: [
                              Colors.white,
                              Colors.blue,
                              Colors.blue,
                            ],
                          ),
                        ),
                        child: Obx(() => controller.isloading.value
                            ? const Center(child: CircularProgressIndicator())
                            : TextButton(
                                onPressed: () {
                                  controller.signUp(emailController.text.trim(),
                                      passController.text.trim());
                                },
                                child: const Center(
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              )),
                      ),

                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text('Already have an account?'),
                          TextButton(
                            onPressed: () {
                              Get.to(()=>const LoginScreen(),transition: Transition.leftToRight,duration: const Duration(seconds: 1));
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hintText, IconData icon,
      {bool isPassword = false,
      TextInputType keyboardType = TextInputType.text}) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        boxShadow: [
          const BoxShadow(
            color: Colors.white,
            blurRadius: 15,
            spreadRadius: 1.0,
            offset: Offset(6, 6),
          ),
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            spreadRadius: 1.0,
            offset: const Offset(-6, -6),
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            prefixIcon: Icon(icon),
          ),
          obscureText: isPassword,
          keyboardType: keyboardType,
        ),
      ),
    );
  }
}
