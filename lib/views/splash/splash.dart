import 'package:agendador_bronzeamento/animation/rotating_sun.dart';
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RotatingSun(size: 150),
                Text(
                  'Fabi Bronze',
                  style: TextStyle(
                    fontSize: 50,
                    fontFamily: 'DancingScript',
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
            Obx(() => showCircularProgressIndicator.value ? 
                const SizedBox(
                  height: 35, 
                  child: CircularProgressIndicator()
                ) : const SizedBox(height: 35)),
          ],
        ),
      ),
    );
  }
}
