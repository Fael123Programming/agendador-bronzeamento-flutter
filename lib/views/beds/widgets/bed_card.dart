import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/turn_around_blocks.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/bed_card_list_controller.dart';

class BedCardController extends GetxController {
  final int totalCircles = 2;
  Duration totalDuration = const Duration(seconds: 5);
  Rx<Duration> remainingTime = const Duration(seconds: 5).obs;
  RxInt paintedCircles = 0.obs;
  Rx<Color> color = Colors.white.obs;
  Rx<Timer>? timer;
  RxBool stopped = false.obs;
  RxBool active = true.obs;

  void startTimer() {
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
    }).obs;
  }

  @override
  void onClose() {
    timer?.value.cancel();
    super.onClose();
  }
}

class BedCard extends StatelessWidget {
  final String clientName;
  final int bedNumber;
  
  const BedCard({
    super.key,
    required this.clientName, 
    required this.bedNumber,
  });

  @override
  Widget build(context) {
    final controller = BedCardController();
    final BedCardListController listController = Get.find();
    controller.startTimer();
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
              controller.timer?.value.cancel();
              listController.removeCardByClientName(clientName);
            },
            key: ValueKey<String>(clientName),
            child: GestureDetector(
              onTap: () {
                if (controller.stopped.value) {
                  if (controller.paintedCircles.value < controller.totalCircles) {
                    controller.startTimer();
                  } else {
                    controller.timer?.value.cancel();
                    listController.removeCardByClientName(clientName);
                  }
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.pink[50],
                  border: Border.all(color: controller.color.value),
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
                          totalBlocks: controller.totalCircles,
                          paintedBlocks: controller.paintedCircles.value,
                        )),
                        Obx(() => controller.stopped.value ? 
                          Icon(controller.paintedCircles.value == controller.totalCircles ? Icons.done_all : Icons.double_arrow, color: controller.paintedCircles.value == controller.totalCircles ? Colors.green : Colors.black,)
                          : Text(controller.remainingTime.value.toString().split('.')[0])
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ));
  }
}