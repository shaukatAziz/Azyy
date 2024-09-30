import 'package:expenses/Routes/routes_name.dart';
import 'package:expenses/admin_panel/Screens/adminsignup_screen.dart';
import 'package:expenses/screens/bottom_bar.dart';
import 'package:expenses/screens/chat_page.dart';
import 'package:expenses/screens/contact_us.dart';
import 'package:expenses/screens/expense_records.dart';
import 'package:expenses/screens/Expenses_page.dart';
import 'package:expenses/screens/login_Screens.dart';
import 'package:expenses/screens/splash_screen.dart';
import 'package:get/get.dart';

import '../admin_panel/Screens/adminDashboard.dart';
import '../admin_panel/Screens/adminlogin_screen.dart';
import '../screens/signup_screen.dart';

class AppRoutes{
  static dynamic appRoutes()=>[
    GetPage(name: RoutesName.splashscreen, page: ()=> SplashScreen()),

    GetPage(name: RoutesName.userloginscreen, page: ()=> LoginScreen()),
    GetPage(name: RoutesName.usersignupscreen, page: ()=>SignUpScreen()),

    GetPage(name: RoutesName.expenseScreen, page:()=>ExpensesScreen()),
    GetPage(name: RoutesName.expenseRecords, page: ()=>ExpenseRecord()),
    GetPage(name: RoutesName.adminsignupscreen, page: ()=>SignUpPage()),
    GetPage(name: RoutesName.adminLoginScreen, page: ()=>LoginPage()),

    GetPage(name: RoutesName.admindashboard, page: ()=>AdminDashBoard()),
    GetPage(name: RoutesName.navbar, page: ()=>NavBar()),
    GetPage(name: RoutesName.chatscreen, page: ()=>ChatScreen()),
    GetPage(name: RoutesName.contact, page: ()=>ContactUs()),










  ];
}