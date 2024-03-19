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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.grey),
                borderRadius: const BorderRadius.all(
                  Radius.circular(100),
                ),
              ),
              // color: Colors.black,
              width: 150,
              height: 150,
              child: FittedBox(
                fit: BoxFit.cover,
                child: CircleAvatar(
                  backgroundImage: Image.asset(
                          'assets/fabi.png')
                      .image,
                  radius: 20,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 50),
              child: Obx(() => showCircularProgressIndicator.value ? 
                const SizedBox(
                  height: 35, 
                  child: CircularProgressIndicator()
                ) : const SizedBox(height: 35)),
            ),
          ],
        ),
      ),
    );
  }
}
