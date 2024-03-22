import 'dart:async';
import 'dart:math';

import 'package:agendador_bronzeamento/animation/rotating_sun.dart';
import 'package:agendador_bronzeamento/config/route_paths.dart';
import 'package:agendador_bronzeamento/database/models/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    final ConfigController configController = Get.find();
    final RxBool showFirstMessage = false.obs;
    final RxBool showCircularProgressIndicator = false.obs;
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
    if (configController.firstTimeRunning) {
      Future.delayed(const Duration(seconds: 1), () {
        showFirstMessage.value = true;
        Future.delayed(const Duration(seconds: 3), () {
          showFirstMessage.value = false;
          showCircularProgressIndicator.value = true;
          Future.delayed(const Duration(seconds: 3), () {
            Navigator.pushReplacementNamed(context, RoutePaths.home);
          });
        });
      });
    } else {
      Future.delayed(const Duration(seconds: 1), () {
        showCircularProgressIndicator.value = true;
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pushReplacementNamed(context, RoutePaths.home);
        });
      });
    }
    return Scaffold(
      body: Obx(() {
        if (images.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
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
                Column(
                  children: [
                    const Text(
                      'Fabi Bronze',
                      style: TextStyle(
                        fontSize: 50,
                        fontFamily: 'DancingScript',
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Obx(() => showFirstMessage.value ? SizedBox(
                      width: width * .7,
                      child: const Text(
                        'Você pode alterar os valores padrão indo em Ajustes > Valores Padrão',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ) : Container())
                  ],
                ),
                SizedBox(
                  height: 35, 
                  child: Obx(() => showCircularProgressIndicator.value ? const CircularProgressIndicator() : Container())
                )
              ],
            ),
          ),
        );
      })
    );
  }
}
