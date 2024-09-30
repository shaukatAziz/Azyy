import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/AuthController.dart';
import '../controller/expense_controller.dart';

class ExpensesScreen extends StatefulWidget {
  final String? userId; // Accept userId

  const ExpensesScreen({super.key, this.userId}); // Update constructor

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final ExpensesController controller = Get.put(ExpensesController());
  AuthController contracer = Get.put(AuthController());
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    if (user == null) {
      return const Center(child: Text('User is not logged in.'));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Colors.deepPurple, Colors.blue]),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 60.0, left: 19.0),
              child: Text(
                "Welcome\nBack!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: PopupMenuButton<int>(
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) => [
                const PopupMenuItem<int>(
                  value: 0,
                  child: TextButton(
                    onPressed: null, // Will be handled in onSelected
                    child: Text('Logout'),
                  ),
                ),
              ],
              icon: const Icon(Icons.more_vert, color: Colors.white), // Three-dot icon
            ),
          ),
          // Main Content Area
          Padding(
            padding: const EdgeInsets.only(top: 200),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 70),
                child: Column(
                  children: [
                    TextFormField(
                      controller: controller.productController,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.emoji_food_beverage, color: Colors.indigo),
                        label: Text(
                          "Products",
                          style: TextStyle(
                              color: Colors.indigo, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: controller.amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.money, color: Colors.indigo),
                        label: Text(
                          "Amount",
                          style: TextStyle(
                              color: Colors.indigo, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 70),
                    Obx(() => GestureDetector(
                      onTap: () {
                        controller.saveData();
                      },
                      child: Container(
                        width: 300,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          gradient: const LinearGradient(colors: [
                            Colors.blue,
                            Colors.deepPurple,
                          ]),
                        ),
                        child: Center(
                          child: controller.isloading.value
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                            'Save',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        contracer.signOut(); // Call signOut from AuthController
        break;
    }
  }
}
