import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses/admin_panel/Screens/adminDashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../Routes/routes_name.dart';

class AdminAuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  var isLoading = false.obs;

  Future<void> adminLogin(String email, String password) async {
    isLoading.value = true;
    emailController.clear();
    passController.clear();
    try {
      if(email.isEmpty|| password.isEmpty){
        Get.snackbar('fields', 'all fields are required');
      }
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,

      );

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('admin')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists && userDoc['role'] == 'admin') {
        Get.snackbar(
          'Login',
          'Login Successful',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        
        Get.to(()=>AdminDashBoard(),transition: Transition.leftToRight,duration: Duration(seconds: 1));
      } else {

        Get.snackbar(
          'Error',
          'Access Denied: You are not an admin',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );

        await _auth.signOut();
      }
    } catch (e) {
      Get.snackbar('error', 'admin already exist',snackPosition: SnackPosition.BOTTOM,backgroundColor: Colors.red,colorText: Colors.white);
    }
    finally {
      isLoading.value = false;
    }
  }

  Future<void> adminSignUp(String email, String password) async {
    isLoading.value = true; // Start loading
    try {
      QuerySnapshot adminQuery = await FirebaseFirestore.instance
          .collection('admin')
          .get();

      if (adminQuery.docs.isNotEmpty) {

        Get.snackbar(
          'Error',
          'An admin account already exists. Only one admin is allowed.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseFirestore.instance.collection('admin').doc(userCredential.user!.uid).set({
        'email': email,
        'role': 'admin',
      });

      Get.snackbar(
        'Sign Up',
        'Signup Successful',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      Get.toNamed(RoutesName.adminLoginScreen);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Email already in use',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }


}
