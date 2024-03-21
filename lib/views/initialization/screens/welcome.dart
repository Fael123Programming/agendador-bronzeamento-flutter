
import 'dart:async';
import 'dart:math';

import 'package:agendador_bronzeamento/animation/rotating_sun.dart';
import 'package:agendador_bronzeamento/config/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final random = Random();
    RxList<AssetImage> images = <AssetImage>[].obs;
    RxInt imageIndex = 0.obs;
    (() async {
      final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      images.addAll(assetManifest.listAssets().where((asset) => asset.startsWith('assets/woman')).map((image) => AssetImage(image)));
      imageIndex.value = random.nextInt(images.length);
    })();
    int index = 0;
    String message1 = 'Seja bem-vinda ao seu aplicativo para gestão de bronzes!';
    String message2 = 'Vamos definir alguns valores padrão?';
    RxString message1State = ''.obs;
    RxString message2State = ''.obs;
    Rx<Color> textColor1 = Colors.black.obs;
    Rx<Color> textColor2 = Colors.black.obs;
    RxBool showBtn = false.obs;
    // Future.delayed(const Duration(seconds: 3), () {
      // Navigator.pushReplacementNamed(context, RoutePaths.setDefaultValues);
    // });
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (index == message1.length) {
        timer.cancel();
        textColor1.value = Colors.pink;
        index = 0;
        Future.delayed(const Duration(seconds: 1), () {
          Timer.periodic(const Duration(milliseconds: 50), (timer) {
            if (index == message2.length) {
              timer.cancel();
              textColor2.value = Colors.pink;
              showBtn.value = true;
            } else {
              message2State.value += message2[index++];
            }
          });
        });
      } else {
        message1State.value += message1[index++];
      }
    });
    Timer.periodic(const Duration(seconds: 5), (timer) {
      imageIndex.value = random.nextInt(images.length);
    });
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
                const Text(
                  'Fabi Bronze',
                  style: TextStyle(
                    fontSize: 50,
                    fontFamily: 'DancingScript',
                    fontWeight: FontWeight.bold
                  ),
                ),
                Obx(() => Container(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Text(
                        message1State.value,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'DancingScript',
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: textColor1.value,
                          letterSpacing: 1,
                        ),
                      ),
                      message2State.value.isNotEmpty ? Text(
                        message2State.value,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'DancingScript',
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: textColor2.value,
                          letterSpacing: 1,
                        ),
                      ) : Container(),
                    ],
                  ),
                )),
              ]
            ),
          ),
        );
      }),
      floatingActionButton: Obx(() => showBtn.value ? FloatingActionButton(
          onPressed: () => Navigator.pushReplacementNamed(context, RoutePaths.setDefaultValues),
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: const Icon(
            Icons.arrow_circle_right_rounded, 
            color: Colors.white
          ),
        ) :
        Container()),
    );
  }
}