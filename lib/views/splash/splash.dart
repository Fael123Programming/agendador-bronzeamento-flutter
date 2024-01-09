import 'package:agendador_bronzeamento/config/route_paths.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool showCircularProgressIndicator = false;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() => showCircularProgressIndicator = true);
    });
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, RoutePaths.home);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              child: const CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
