import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/turn_around_blocks.dart';
import 'package:agendador_bronzeamento/models/timing.dart';

class BedCardController extends GetxController {
  RxList<BedCard> bedCards = <BedCard>[].obs;
  RxInt next = 1.obs;

  void addBedCard(BedCard bedCard) {
    bedCards.add(bedCard);
    next.value++;
  }

  void removeBedCard(BedCard bedCard) {
    bedCards.remove(bedCard);
    if (bedCards.isEmpty) {
      next.value = 1;
    }
  }
}

class BedCard extends StatelessWidget {
  final String clientName;
  final int bedNumber;
  final Duration totalDuration;
  final Duration remainingDuration;
  final int totalTurns;
  final int turnsDone;

  const BedCard({
    super.key,
    required this.clientName,
    required this.bedNumber,
    required this.totalDuration,
    required this.remainingDuration,
    required this.totalTurns,
    required this.turnsDone
  });

  @override
  Widget build(context) {
    final TimingsController timingsController = Get.find();
    final timingController = TimingController(
      clientName: clientName,
      totalDuration: totalDuration,
      remainingDuration: remainingDuration.obs,
      totalTurns: totalTurns,
      turnsDone: turnsDone.obs
    );
    timingController.startTimer();
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
              timingController.timer.value.cancel();
              timingsController.deleteTiming(timingController.toTiming());
            },
            key: ValueKey<String>(clientName),
            child: GestureDetector(
              onTap: () {
                if (timingController.stopped.value) {
                  if (timingController.turnsDone.value < timingController.totalTurns) {
                    timingController.startTimer();
                  } else {
                    timingController.timer.value.cancel();
                    timingsController.deleteTiming(timingController.toTiming());
                  }
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.pink[50],
                  border: Border.all(color: timingController.color.value),
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
                          totalBlocks: timingController.totalTurns,
                          paintedBlocks: timingController.turnsDone.value,
                        )),
                        Obx(() => timingController.stopped.value ? 
                          Icon(
                            timingController.turnsDone.value == timingController.totalTurns ? 
                            Icons.done_all : 
                            Icons.double_arrow, 
                            color: timingController.turnsDone.value == timingController.totalTurns ?
                            Colors.green : 
                            Colors.black
                          )
                          : Text(timingController.remainingDuration.value.toString().split('.')[0])
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