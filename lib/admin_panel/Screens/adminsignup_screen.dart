import 'package:expenses/Routes/routes_name.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/adminAuth_controller.dart';
import '../widgets/clipper.dart';
import 'adminlogin_screen.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final AdminAuthController controller = Get.put(AdminAuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClipPath(
                clipper: Clippertwo(),
                child: Container(
                  height: Get.height * 0.5,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.black54,
                        Colors.blue,
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 70, left: 30),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.white),
                        children: [
                          TextSpan(
                            text: 'Create\n',
                            style: TextStyle(color: Colors.white, fontSize: 40),
                          ),
                          TextSpan(
                            text: 'Account',
                            style: TextStyle(color: Colors.white, fontSize: 34),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: controller.emailController, // Assign the controller
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your Email',
                        hintStyle: TextStyle(color: Colors.black54), // Change hint text color
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 1),
                        ),
                        prefixIcon: Icon(Icons.email, color: Colors.blue), // Icon inside field
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                    SizedBox(height: 20),

                    TextFormField(
                      controller: controller.passController, // Assign the controller
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your Password',
                        hintStyle: TextStyle(color: Colors.black54), // Change hint text color
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 1),
                        ),
                        prefixIcon: Icon(Icons.lock, color: Colors.blue), // Icon inside field
                        contentPadding: EdgeInsets.all(16),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 40),
                    // Sign Up Button

                   Obx(()=> controller.isLoading.value? CircularProgressIndicator(): Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Text(
                         'Sign Up',
                         style: TextStyle(color: Colors.blue, fontSize: 23, fontWeight: FontWeight.bold),
                       ),
                       SizedBox(width: 40),
                       CircleAvatar(
                         radius: 30,
                         backgroundColor: Colors.blue,
                         child: IconButton(
                           onPressed: () {
                             controller.adminSignUp(
                               controller.emailController.text.trim(),
                               controller.passController.text.trim(),
                             );

                           },
                           icon: Icon(Icons.arrow_forward, color: Colors.white),
                         ),
                       ),
                     ],

                   ),),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:

                    [

                      Text('already have an account?'),
                      SizedBox(width: 10,),
                      TextButton(
                        onPressed: (){
                          Get.to(()=>LoginPage(),transition: Transition.leftToRight,duration: Duration(seconds: 1));
                        },
                          child: Text('SignIn',style: TextStyle(color: Colors.blue),))
                    ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
