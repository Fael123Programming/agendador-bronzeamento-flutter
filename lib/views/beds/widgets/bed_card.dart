import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BedCardController extends GetxController {
  final int totalCircles = 4;
  Duration totalDuration = const Duration(seconds: 10);
  Rx<Duration> remainingTime = const Duration(seconds: 10).obs;
  RxInt paintedCircles = 0.obs;
  Rx<Color> color = Colors.white.obs;
  Timer? timer;
  RxBool stopped = false.obs;

  void startTimer() {
    color.value = Colors.white;
    paintedCircles.value++;
    stopped.value = false;
    remainingTime.value = Duration(seconds: totalDuration.inSeconds);
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingTime.value.inSeconds > 1) {
        remainingTime.value = remainingTime.value - const Duration(seconds: 1);
      } else {
        timer?.cancel();
        color.value = Colors.pink;
        stopped.value = true;
      }
    });
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}

class BedCard {
  final controller = BedCardController();
  final String clientName;
  final int bedNumber;
  final RxBool dismissed = false.obs;
 
  BedCard({
    required this.clientName, 
    required this.bedNumber, 
  });
}