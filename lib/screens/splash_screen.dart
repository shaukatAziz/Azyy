import 'package:expenses/Routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/AuthController.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));

    if (authController.isLoggedIn.value) {
      String? userId = authController.userId;
      Get.offNamed(RoutesName.navbar,arguments: {'UserId':userId});
    } else {
      Get.offNamed(RoutesName.userloginscreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: Get.height*10,
              width: Get.width*10,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                  Colors.blue.withOpacity(0.1),
                  Colors.blue, Colors.blue

                ])
              ),
              child: const Center(child: Image(image: AssetImage('data/asset/images/exx.png'),width: 180,height: 180,)),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20,bottom: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Center(child: Text('@copywrite SWASTU TECH PVT LTD LIMITED',style: TextStyle(fontStyle: FontStyle.italic,color: Colors.white38,fontSize: 10),))
                ],
              ),
            )
          ],
        ),
      )

    );
  }
}
