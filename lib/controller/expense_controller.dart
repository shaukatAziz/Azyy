import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses/Routes/routes_name.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart'; // Import FirebaseAuth

class ExpensesController extends GetxController {
  final TextEditingController productController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  var isloading = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Authentication instance

  void saveData() async {
    String product = productController.text;
    String amount = amountController.text;

    if (product.isEmpty || amount.isEmpty) {
      Get.snackbar(
        'Error',
        'All fields are required',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    User? user = _auth.currentUser; // Get the current user
    if (user == null) {
      Get.snackbar(
        'Error',
        'User not logged in',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    else{
      Get.toNamed(RoutesName.expenseRecords);
    }

    String userId = user.uid;

    isloading(true);
    try {
      CollectionReference ref = FirebaseFirestore.instance.collection('expenses');
      await ref.add({
        'product': product,
        'amount': amount,
        'userId': userId, // Save the user ID with the expense data
        'timestamp': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        'Success',
        'Data saved successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      productController.clear();
      amountController.clear();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save data',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isloading(false);
    }
  }
}
