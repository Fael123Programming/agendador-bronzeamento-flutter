import 'dart:async';

import 'package:agendador_bronzeamento/database/models/bronze.dart';
import 'package:agendador_bronzeamento/database/models/client.dart';
import 'package:agendador_bronzeamento/utils/notification_service.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/turn_around_blocks.dart';

class BedCardListController extends GetxController {
  final RxList<BedCard> list = <BedCard>[].obs;
  
  // void add(BedCard bedCard) {
  //   _list.add(bedCard);
  //   isEmpty = _list.isEmpty;
  // }

  // void remove(BedCard bedCard) {
  //   _list.remove(bedCard);
  //   isEmpty = _list.isEmpty;
  // }

  // BedCard? findByClientName(String clientName) {
  //   try {
  //     return _list.where((bedCard) => bedCard.bedCardController.client.name == clientName).first;
  //   } catch(err) {
  //     return null;
  //   }
  // }

  // BedCard? findByBedNumber(int bedNumber) {
  //   try {
  //     return _list.where((bedCard) => bedCard.bedCardController.bedNumber == bedNumber).first;
  //   } catch(err) {
  //     return null;
  //   }
  // }

  // List<BedCard> findContainingClientName(String clientName) {
  //   return _list.where(
  //         (bedCard) => bedCard.bedCardController.client.name.toLowerCase().contains(
  //       clientName.toLowerCase(),
  //     ),
  //   ).toList();
  // }

  // List<BedCard> toList() {
  //   return _list.toList();
  // }

  // List<String> getNameOfAllClients({bool lowercase = true}) {
  //   if (lowercase) {
  //     return _list.map((bedCard) => bedCard.bedCardController.client.name.toLowerCase()).toList();
  //   }
  //   return _list.map((bedCard) => bedCard.bedCardController.client.name).toList();
  // }
}

class BedCardController extends GetxController {
  BedCardController({
    required this.client,
    required this.price,
    required this.totalSecs,
    required this.remainingSecs,
    required this.turnArounds,
    required this.bedNumber,
    required this.turnsDone,
    this.listener
  });

  final Client client;
  final String price;
  final int turnArounds;
  final int bedNumber;
  final RxInt turnsDone;
  final int totalSecs;
  final RxBool stopped = false.obs;
  final RxBool active = true.obs;
  final time = ''.obs;
  final Rx<Color> color = Colors.white.obs;
  final DateTime timestamp = DateTime.now();
  Function()? listener;

  int remainingSecs;
  Timer? _timer;

  @override
  void onClose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.onClose();
  }

  void tryStopTimer() {
    if (_timer != null) {
      _timer!.cancel();
      turnsDone.value++;
      color.value = Colors.pink;
      stopped.value = true;
      time.value = '';
    }
  }

  void startTimer() {
    const duration = Duration(seconds: 1);
    color.value = Colors.white;
    stopped.value = false;
    remainingSecs = totalSecs;
    _timer = Timer.periodic(duration, (t) async {
      int hours = remainingSecs ~/ 3600;
      int mins = remainingSecs % 3600 ~/ 60;
      int secs = remainingSecs % 3600 % 60;
      time.value = "${hours.toString().padLeft(2, "0")}:${mins.toString().padLeft(2, "0")}:${secs.toString().padLeft(2, "0")}";
      if (time.value == '00:00:00') {
        time.value = '';
      }
      if (remainingSecs > 0) {
        remainingSecs--;
      } else {
        if (listener != null) {
          listener!();
        }
        t.cancel();
        turnsDone.value++;
        color.value = Colors.pink;
        stopped.value = true;
        String clientFirstName = client.name.split(' ')[0];
        await NotificationService().showNotification(
          id: bedNumber,
          title: 'Maca $bedNumber ($clientFirstName)', 
          body: turnsDone.value == turnArounds ? 'Bronze finalizado!' : 'Virada ${turnsDone.value} finalizada!',
          actionTitle: turnsDone.value == turnArounds ? 'Encerrar Bronze' : 'Próxima Virada',
        );
      }
    });
  }
}

class BedCard extends StatelessWidget {
  final BedCardController bedCardController;
 
  const BedCard({
    super.key,
    required this.bedCardController
  });

  @override
  Widget build(context) {
    final BedCardListController listController = Get.find();
    final BronzeController bronzeController = Get.find();
    RxBool skipTurnAroundDialogOpen = false.obs;
    bedCardController.listener = () {
      if (skipTurnAroundDialogOpen.value) {
        Get.back();
        skipTurnAroundDialogOpen.value = false;
      }
    };
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
              final thisBedCard = listController.list.where((bedCard) => bedCard.bedCardController.client.name == bedCardController.client.name).first;
              thisBedCard.bedCardController.tryStopTimer();
              listController.list.remove(thisBedCard);
              await NotificationService().cancelNotification(bedCardController.bedNumber);
            },
            key: ValueKey<String>(bedCardController.client.name),
            child: GestureDetector(
              onTap: () async {
                if (bedCardController.stopped.value) {
                  await NotificationService().cancelNotification(bedCardController.bedNumber);
                  if (bedCardController.turnsDone.value < bedCardController.turnArounds) {
                    bedCardController.startTimer();
                  } else {
                    final thisBedCard = listController.list.where((bedCard) => bedCard.bedCardController.client.name == bedCardController.client.name).first;
                    listController.list.remove(thisBedCard);
                    await bronzeController.insert(
                      Bronze.toSave(
                        clientId: bedCardController.client.id, 
                        totalSecs: bedCardController.totalSecs, 
                        turnArounds: bedCardController.turnArounds, 
                        price: Decimal.parse(bedCardController.price), 
                        timestamp: bedCardController.timestamp
                      )
                    );
                  }
                } else {
                  skipTurnAroundDialogOpen.value = true;
                  Get.dialog(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Material(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Finalizar Virada',
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 15),
                                    const Text(
                                      'Deseja realmente finalizar essa virada?',
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: const Size(0, 45),
                                              backgroundColor: const Color.fromARGB(255, 255, 17, 0),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                            onPressed: () => Get.back(),
                                            child: const Text(
                                              'Não',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: const Size(0, 45),
                                              backgroundColor: const Color.fromARGB(255, 0, 255, 8),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                            onPressed: () async {
                                              bedCardController.tryStopTimer();
                                              Get.back();
                                            },
                                            child: const Text(
                                              'Sim',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
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
                          bedCardController.client.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '#${bedCardController.bedNumber}',
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
                          totalBlocks: bedCardController.turnArounds,
                          paintedBlocks: bedCardController.turnsDone.value,
                        )),
                        Obx(() => bedCardController.stopped.value ? 
                          Icon(
                            bedCardController.turnsDone.value == bedCardController.turnArounds ? 
                            Icons.done_all : 
                            Icons.double_arrow, 
                            color: bedCardController.turnsDone.value == bedCardController.turnArounds ?
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