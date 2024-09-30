import 'package:expenses/Routes/routes_name.dart';
import 'package:expenses/admin_panel/Screens/adminlogin_screen.dart';
import 'package:expenses/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/AuthController.dart';
import '../widgets/Clipper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final AuthController controller = Get.put(AuthController());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              ClipPath(
                clipper: Cliperone(),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomLeft,
                      stops: const [0.4, 0.8, 1],
                      colors: [
                        Colors.blue,
                        Colors.blue.withOpacity(0.5),
                        Colors.blue,
                      ],
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(top: 30, left: 30),
                    child: Text(
                      'Login',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 250),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      padding: const EdgeInsets.only(
                          bottom: 10, left: 15, right: 15, top: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 70),
                        child: Column(
                          children: [
                            buildInputField(
                              controller: emailController,
                              hintText: 'Email',
                              icon: Icons.email,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!GetUtils.isEmail(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),

                            // Password Field
                            buildInputField(
                              controller: passController,
                              hintText: 'Password',
                              icon: Icons.lock,
                              isPassword: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // Login Button
                            Obx(() => controller.isloading.value
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 50, vertical: 15),
                                    ),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        controller.login(emailController.text.trim(),passController.text.trim());
                                      }
                                    },
                                    child: const Text('Login',
                                        style: TextStyle(color: Colors.white)),
                                  )),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text(
                                  'Dont have an account? ',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Get.off(()=>SignUpScreen(),transition: Transition.leftToRight,duration: Duration(seconds: 1));
                                  },
                                  child: const Text(
                                    'SignUp',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextButton(
                              onPressed: (){
                                Get.to(()=>LoginPage(),transition: Transition.leftToRight,duration:Duration(seconds: 1));
                              },
                              child: Text(
                                'admin?',
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontStyle: FontStyle.italic),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          icon: Icon(icon, color: Colors.blue),
        ),
        validator: validator,
      ),
    );
  }
}
