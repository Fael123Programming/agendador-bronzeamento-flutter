import 'package:agendador_bronzeamento/config/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Splash extends StatelessWidget {
  Splash({super.key});
  
  final RxBool showCircularProgressIndicator = false.obs;

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), () {
      showCircularProgressIndicator.value = true;
    });
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, RoutePaths.home);
    });
    return Scaffold(
      backgroundColor: Colors.pink,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: const BorderRadius.all(
                  Radius.circular(100),
                ),
              ),
              // color: Colors.white,
              child: const Image(
                image: AssetImage('assets/tanning.png'),
                width: 80,
                height: 80,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 50),
              child: Obx(() => showCircularProgressIndicator.value ? 
                const SizedBox(
                  height: 40, 
                  child: CircularProgressIndicator()
                ) : const SizedBox(height: 40)),
            ),
          ],
        ),
      ),
    );
  }
}
