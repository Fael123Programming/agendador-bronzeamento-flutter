import 'dart:async';

import 'package:agendador_bronzeamento/database/models/bronze.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/turn_around_blocks.dart';

class BedCardListController extends GetxController {
  RxList<BedCard> list = <BedCard>[].obs;
}

class BedCardController extends GetxController {
  BedCardController({
    required this.clientName,
    required this.price,
    required this.totalSecs,
    required this.remainingSecs,
    required this.totalTurns,
    required this.turnsDone
  });

  final String clientName;
  final String price;
  final int totalTurns;
  final RxInt turnsDone;
  final int totalSecs;
  final RxBool stopped = false.obs;
  final RxBool active = true.obs;
  final time = ''.obs;
  final Rx<Color> color = Colors.white.obs;
  final DateTime timestamp = DateTime.now();

  int remainingSecs;
  Timer? _timer;

  @override
  void onClose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.onClose();
  }

  void startTimer() {
    const duration = Duration(seconds: 1);
    color.value = Colors.white;
    stopped.value = false;
    remainingSecs = totalSecs;
    _timer = Timer.periodic(duration, (t) async {
      if (remainingSecs > 0) {
        int hours = remainingSecs ~/ 3600;
        int mins = remainingSecs % 3600 ~/ 60;
        int secs = remainingSecs % 3600 % 60;
        time.value = "${hours.toString().padLeft(2, "0")}:${mins.toString().padLeft(2, "0")}:${secs.toString().padLeft(2, "0")}";
        remainingSecs--;
      } else {
        int hours = totalSecs ~/ 3600;
        int mins = totalSecs % 3600 ~/ 60;
        int secs = totalSecs % 3600 % 60;
        time.value = "${hours.toString().padLeft(2, "0")}:${mins.toString().padLeft(2, "0")}:${secs.toString().padLeft(2, "0")}";
        turnsDone.value++;
        t.cancel();
        color.value = Colors.pink;
        stopped.value = true;
      }
    });
  }
}

class BedCard extends StatelessWidget {
  final BedCardController bedCardController;
  final int bedNumber;

  const BedCard({
    super.key,
    required this.bedCardController,
    required this.bedNumber
  });

  @override
  Widget build(context) {
    final BedCardListController listController = Get.find();
    final BronzeController bronzeController = Get.find();
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
            onDismissed: (direction) async {
              final thisBedCard = listController.list.where((bedCard) => bedCard.bedCardController.clientName == bedCardController.clientName).first;
              listController.list.remove(thisBedCard);
            },
            key: ValueKey<String>(bedCardController.clientName),
            child: GestureDetector(
              onTap: () async {
                if (bedCardController.stopped.value) {
                  if (bedCardController.turnsDone.value < bedCardController.totalTurns) {
                    bedCardController.startTimer();
                  } else {
                    final thisBedCard = listController.list.where((bedCard) => bedCard.bedCardController.clientName == bedCardController.clientName).first;
                    listController.list.remove(thisBedCard);
                    await bronzeController.addBronze(
                      Bronze(
                        clientName: bedCardController.clientName, 
                        totalSecs: bedCardController.totalSecs, 
                        totalTurns: bedCardController.totalTurns, 
                        price: Decimal.parse(bedCardController.price), 
                        timestamp: bedCardController.timestamp
                      )
                    );
                  }
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.pink[50],
                  border: Border.all(color: bedCardController.color.value),
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
                          bedCardController.clientName,
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
                          totalBlocks: bedCardController.totalTurns,
                          paintedBlocks: bedCardController.turnsDone.value,
                        )),
                        Obx(() => bedCardController.stopped.value ? 
                          Icon(
                            bedCardController.turnsDone.value == bedCardController.totalTurns ? 
                            Icons.done_all : 
                            Icons.double_arrow, 
                            color: bedCardController.turnsDone.value == bedCardController.totalTurns ?
                            Colors.green : 
                            Colors.black
                          )
                          : Text(bedCardController.time.value)
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