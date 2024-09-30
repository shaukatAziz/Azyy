import 'package:expenses/Routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/adminAuth_controller.dart';
import '../widgets/clipper.dart';
import 'adminsignup_screen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AdminAuthController controller = Get.put(AdminAuthController());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

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
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.blue,
                        Colors.white,
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 70, left: 30),
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(color: Colors.white),
                        children: [
                          TextSpan(
                            text: 'Welcome\n',
                            style: TextStyle(color: Colors.white, fontSize: 40),
                          ),
                          TextSpan(
                            text: 'SignIn',
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
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your Email',
                        hintStyle: TextStyle(color: Colors.black54),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 1),
                        ),
                        prefixIcon: Icon(Icons.email, color: Colors.blue),
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Password TextField
                    TextFormField(
                      controller: passController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your Password',
                        hintStyle: TextStyle(color: Colors.black54),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 1),
                        ),
                        prefixIcon: Icon(Icons.lock, color: Colors.blue),
                        contentPadding: EdgeInsets.all(16),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 40),

                    Obx(() {
                      return controller.isLoading.value
                          ? const CircularProgressIndicator()
                          : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Sign In',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 40),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.blue,
                            child: IconButton(
                              onPressed: () {
                                controller.adminLogin(
                                  emailController.text.trim(),
                                  passController.text.trim(),
                                );
                              },
                              icon: const Icon(Icons.arrow_forward, color: Colors.white),
                            ),
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        const SizedBox(width: 20),
                        TextButton(
                          onPressed: () {
                            Get.to(()=>SignUpPage(),transition: Transition.leftToRight,duration: Duration(seconds: 1));
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
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
