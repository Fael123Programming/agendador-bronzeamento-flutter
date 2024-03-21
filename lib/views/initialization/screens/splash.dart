import 'dart:async';
import 'dart:math';

import 'package:agendador_bronzeamento/animation/rotating_sun.dart';
import 'package:agendador_bronzeamento/config/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Splash extends StatelessWidget {
  Splash({super.key});
  
  final RxBool showCircularProgressIndicator = false.obs;

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    RxInt imageIndex = 0.obs;
    RxList<AssetImage> images = <AssetImage>[].obs;
    (() async {
      final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      images.addAll(assetManifest.listAssets().where((asset) => asset.startsWith('assets/woman')).map((image) => AssetImage(image)));
      imageIndex.value = random.nextInt(images.length);
    })();
    return Scaffold(
      body: Obx(() {
        if (images.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        Future.delayed(const Duration(seconds: 1), () {
          showCircularProgressIndicator.value = true;
        });
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pushReplacementNamed(context, RoutePaths.home);
        });
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: images[imageIndex.value],
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
            ),
          ),
          child: Container(
            margin: EdgeInsets.only(top: height * .01),
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const RotatingSun(size: 150),
                const Text(
                  'Fabi Bronze',
                  style: TextStyle(
                    fontSize: 50,
                    fontFamily: 'DancingScript',
                    fontWeight: FontWeight.bold
                  ),
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
      })
    );
  }
}
