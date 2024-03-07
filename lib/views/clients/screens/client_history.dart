import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agendador_bronzeamento/database/models/client.dart';
import 'package:agendador_bronzeamento/database/models/bronze.dart';
import 'package:agendador_bronzeamento/utils/validator.dart';

Widget showDependent(Widget widget, RxBool logic) {
  if (logic.value) {
    return widget;
  }
  return Container();
}

class ClientHistory extends StatelessWidget {
  const ClientHistory({super.key, required this.clientData});

  final User clientData;

  @override
  Widget build(context) {
    final BronzeController bronzeController = Get.find();
    List<Bronze> bronzes = bronzeController.findBronzesOfClientWithName(clientData.name);
    RxBool reportShow = false.obs;
    int sumSecs = bronzes.fold(0, (previousValue, bronze) => previousValue + bronze.totalSecs);
    int totHours = sumSecs ~/ 3600;
    int totMins = sumSecs % 3600 ~/ 60;
    int totSecs = sumSecs % 3600 % 60;
    List<RxBool> shows = [
      false.obs,
      false.obs,
      false.obs,
      false.obs
    ];
    const box10 = SizedBox(height: 20);
    const box5 = SizedBox(height: 10);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bronzes de ${clientData.name.split(" ")[0]}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            // fontFamily: 'DancingScript'
          ),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Column(
              children: [
                Expanded(
                    child: ListView.builder(
                        itemCount: bronzes.length,
                        itemBuilder: (context, index) {
                          Bronze bronze = bronzes[index];
                          int hours = bronze.totalSecs ~/ 3600;
                          int mins = bronze.totalSecs % 3600 ~/ 60;
                          int secs = bronze.totalSecs % 3600 % 60;
                          return Container(
                              height: 80,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),
                              margin: const EdgeInsets.all(10),
                              child: ListTile(
                                title: Text(
                                  Validator.formatDatetime(bronze.timestamp),
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 5),
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(30),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.u_turn_left,
                                            color: Colors.grey,
                                          ),
                                          Text(bronze.totalTurns.toString())
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(right: 5),
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(30),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.timer,
                                            color: Colors.grey,
                                          ),
                                          Text("${hours.toString().padLeft(2, "0")}:${mins.toString().padLeft(2, "0")}:${secs.toString().padLeft(2, "0")}")
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(30),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.monetization_on,
                                            color: Colors.grey,
                                          ),
                                          Text(bronze.price.toStringAsFixed(2))
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          );
                        })
                ),
                Obx(() => Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
                  ),
                  child: Column(
                    children: [
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                              'Relatório',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            IconButton(
                                onPressed: () {
                                  if (reportShow.value) {
                                    for (RxBool show in shows) {
                                      show.value = !show.value;
                                    }
                                  } else {
                                    for (RxBool show in shows.reversed) {
                                      show.value = !show.value;
                                    }
                                  }
                                  reportShow.value = !reportShow.value;
                                },
                                icon: Icon(reportShow.value ? Icons.arrow_downward : Icons.arrow_upward)
                            )
                          ]),
                      showDependent(box10, shows[0]),
                      showDependent(
                          Row(
                            children: [
                              const Icon(
                                Icons.sunny,
                                color: Colors.grey,
                              ),
                              Text(bronzes.length.toString())
                            ],
                          ), shows[0]
                      ),
                      showDependent(box5, shows[1]),
                      showDependent(Row(
                        children: [
                          const Icon(
                            Icons.u_turn_left,
                            color: Colors.grey,
                          ),
                          Text(bronzes.fold(0, (previousValue, bronze) => previousValue + bronze.totalTurns).toString())
                        ],
                      ), shows[1]),
                      showDependent(box5, shows[2]),
                      showDependent(Row(
                        children: [
                          const Icon(
                            Icons.timer,
                            color: Colors.grey,
                          ),
                          Text("${totHours.toString().padLeft(2, "0")}:${totMins.toString().padLeft(2, "0")}:${totSecs.toString().padLeft(2, "0")}")
                        ],
                      ), shows[2]),
                      showDependent(box5, shows[3]),
                      showDependent(Row(
                        children: [
                          const Icon(
                            Icons.monetization_on,
                            color: Colors.grey,
                          ),
                          Text(bronzes.fold(Decimal.zero, (previousValue, bronze) => previousValue + bronze.price).toStringAsFixed(2))
                        ],
                      ), shows[3])
                    ],
                  ),
                ))
              ],
            )
    ));
  }
}
