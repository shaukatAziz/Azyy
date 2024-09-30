import 'package:expenses/Routes/routes_name.dart';
import 'package:expenses/screens/chat_page.dart';
import 'package:expenses/screens/contact_us.dart';
import 'package:expenses/screens/Expenses_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/navigation_controller.dart';

class NavBar extends StatelessWidget {
  final BottomNavController navController = Get.put(BottomNavController());
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final String? userId = Get.arguments?['userId'];

    return Obx(() {
      return Scaffold(
        backgroundColor: Colors.white,
        body: IndexedStack(
          index: navController.selectedIndex.value,
          children: [
            ExpensesScreen(userId: userId ?? ''),
            ChatScreen()
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: navController.selectedIndex.value,
          onTap: (index) => navController.changeIndex(index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.money),
              label: 'Expenses',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.contact_phone),
              label: 'Contact Us',
            ),
          ],
        ),
      );
    });
  }
}
