import 'dart:async';
import 'package:agendador_bronzeamento/models/bed_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/turn_around_blocks.dart';

BedCardWidget getWidgetFromModel(BedCard bedCard) {
  BedCardWidget widget = BedCardWidget(
    clientName: bedCard.clientName, 
    bedNumber: bedCard.bedNumber,
    totalDuration: bedCard.totalDuration,
    remainingTime: bedCard.remainingTime,
    totalCircles: bedCard.totalCircles,
    paintedCircles: bedCard.paintedCircles,
  );

  return widget;
}

class TimeController extends GetxController {
  TimeController({
    required this.totalDuration,
    required this.remainingTime,
    required this.totalCircles,
    required this.paintedCircles
  });

  int totalCircles;
  Duration totalDuration;
  Rx<Duration> remainingTime;
  RxInt paintedCircles;

  Rx<Color> color = Colors.white.obs;
  Rx<Timer>? timer;
  RxBool stopped = false.obs;
  RxBool active = true.obs;

  void startTimer() {
    // final BedCardController bedController = Get.find();
    color.value = Colors.white;
    stopped.value = false;
    remainingTime.value = Duration(seconds: totalDuration.inSeconds);
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (remainingTime.value.inSeconds > 1) {
        remainingTime.value = remainingTime.value - const Duration(seconds: 1);
      } else {
        paintedCircles.value++;
        timer?.value.cancel();
        color.value = Colors.pink;
        stopped.value = true;
      }
      // bedController.updateBedCard(oldBedCard, newBedCard);
    }).obs;
  }

  @override
  void onClose() {
    timer?.value.cancel();
    super.onClose();
  }
}

class BedCardWidget extends StatelessWidget {
  final String clientName;
  final int bedNumber;
  final Duration totalDuration;
  final Duration remainingTime;
  final int totalCircles;
  final int paintedCircles;

  const BedCardWidget({
    super.key,
    required this.clientName,
    required this.bedNumber,
    required this.totalDuration,
    required this.remainingTime,
    required this.totalCircles,
    required this.paintedCircles
  });

  @override
  Widget build(context) {
    final timeController = TimeController(
      totalDuration: totalDuration,
      remainingTime: remainingTime.obs,
      totalCircles: totalCircles,
      paintedCircles: paintedCircles.obs
    );
    final BedCardController bedController = Get.find();
    timeController.startTimer();
    return Obx(() => Dismissible(
            background: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
                color: Colors.red,
              ),
              alignment: AlignmentDirectional.center,
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            onDismissed: (direction) {
              timeController.timer?.value.cancel();
              bedController.removeCardByClientName(clientName);
            },
            key: ValueKey<String>(clientName),
            child: GestureDetector(
              onTap: () {
                if (timeController.stopped.value) {
                  if (timeController.paintedCircles.value < timeController.totalCircles) {
                    timeController.startTimer();
                  } else {
                    timeController.timer?.value.cancel();
                    bedController.removeCardByClientName(clientName);
                  }
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.pink[50],
                  border: Border.all(color: timeController.color.value),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          clientName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '#$bedNumber',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(() => TurnAroundBlocks(
                          totalBlocks: timeController.totalCircles,
                          paintedBlocks: timeController.paintedCircles.value,
                        )),
                        Obx(() => timeController.stopped.value ? 
                          Icon(
                            timeController.paintedCircles.value == timeController.totalCircles ? 
                            Icons.done_all : 
                            Icons.double_arrow, 
                            color: timeController.paintedCircles.value == timeController.totalCircles ?
                            Colors.green : 
                            Colors.black
                          )
                          : Text(timeController.remainingTime.value.toString().split('.')[0])
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ),
      );
  }
}