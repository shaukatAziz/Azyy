import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses/screens/Expenses_page.dart';
import 'package:expenses/screens/bottom_bar.dart';
import 'package:expenses/screens/login_Screens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var isloading = false.obs;
  var isLoggedIn = false.obs;
  String? userId; // Store the logged-in user's ID

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  void onInit() {
    super.onInit();
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        isLoggedIn.value = false;
      } else {
        isLoggedIn.value = true;
        userId = user.uid;
      }
    });
  }


  void login(String email, String password) async {
    try {
      isloading.value = true;
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      userId = userCredential.user!.uid;


      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        // Optionally, you can save the user data to a variable or state management solution
        var userData = userDoc.data() as Map<String, dynamic>;
        // Access user data as needed
      }

      Get.offAll(() => NavBar(),
          transition: Transition.leftToRight,
          duration: const Duration(seconds: 1));
      Get.snackbar('Login', 'Login successful',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Login Error', 'Invalid credentials',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isloading.value = false;
    }
  }

  // SignUp function
  void signUp(String email, String password) async {
    String name = nameController.text.trim();
    String address = addressController.text.trim();
    String phone = phoneController.text.trim();

    if (name.isEmpty || address.isEmpty || phone.isEmpty) {
      Get.snackbar('Error', 'All fields are required!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    try {
      isloading.value = true;

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;
      userId = uid; // Store the user ID after signup

      // Store additional user data in Firestore
      await _firestore.collection('users').doc(uid).set({
        'name': name,
        'address': address,
        'phone': phone,
        'email': email,
        'createdAt': Timestamp.now(),
      });

      Get.offAll(() => LoginScreen(),
          transition: Transition.leftToRight,
          duration: const Duration(seconds: 1));
      Get.snackbar('SignUp', 'SignUp successful!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Sign Up Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isloading.value = false;
    }
  }

  // Logout function
  void signOut() async {
    await _auth.signOut();
    userId = null; // Clear userId on sign out
    Get.offAll(() => LoginScreen(),
        transition: Transition.leftToRight,
        duration: const Duration(seconds: 1));
  }
}
