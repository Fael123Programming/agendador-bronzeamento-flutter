import 'package:agendador_bronzeamento/database/models/client.dart';
import 'package:agendador_bronzeamento/views/clients/controllers/filtered_bronzes_controller.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:agendador_bronzeamento/database/models/bronze.dart';
import 'package:agendador_bronzeamento/utils/validator.dart';
import 'package:agendador_bronzeamento/views/clients/utils/month_year_pair.dart';
import 'package:agendador_bronzeamento/views/clients/utils/functions.dart';

class Bronzes extends StatelessWidget {
  const Bronzes({super.key});

  List<Widget> getModalOptions(BuildContext context) {
    final FilteredBronzesController filteredController = Get.find();
    List<Widget> options = <Widget>[];
    options.add(
      Material(
        child: ListTile(
          tileColor: 'Tudo' == filteredController.type.value ? const Color.fromARGB(255, 235, 235, 235) : Colors.white,
          title: Text(
            'Tudo',
            style: TextStyle(
              fontWeight: 'Tudo' == filteredController.type.value ? FontWeight.bold : FontWeight.normal,
              fontSize: 18
            ),
          ),
          trailing: const Icon(Icons.done_all_sharp),
          onTap: () {
            Navigator.pop(context);
            if ('Tudo' != filteredController.type.value) {
              filteredController.filterAll();
            }
          },
        ),
      ),
    );
    List<MonthYearPair> pairs = <MonthYearPair>[];
    pairs.addAll(filteredController.all.map((e) => MonthYearPair(month: e.timestamp.month, year: e.timestamp.year)));
    pairs = pairs.toSet().toList();
    pairs.sort((p1, p2) => p2.compareTo(p1));
    for (MonthYearPair pair in pairs) {
      options.add(
        Material(
          child: ListTile(
            tileColor: pair.toString() == filteredController.type.value ? const Color.fromARGB(255, 235, 235, 235) : Colors.white,
            title: Text(
              pair.toString(),
              style: TextStyle(
                fontWeight: pair.toString() == filteredController.type.value ? FontWeight.bold : FontWeight.normal,
                fontSize: 18
              ),
            ),
            trailing: const Icon(Icons.calendar_month),
            onTap: () {
              Navigator.pop(context);
              if (pair.toString() != filteredController.type.value) {
                filteredController.filterMonthYearPair(pair);
              }
            },
          ),
        ),
      );
    }
    return options;
  }

  @override
  Widget build(context) {
    final ClientController clientController = Get.find();
    final BronzeController bronzeController = Get.find();
    final FilteredBronzesController filteredController = Get.put(FilteredBronzesController(bronzeController.bronzes));
    RxBool reportShown = false.obs;
    
    List<RxBool> shows = [
      false.obs,
      false.obs,
      false.obs,
      false.obs
    ];
    const box10 = SizedBox(height: 20);
    const box5 = SizedBox(height: 10);
    double width = MediaQuery.of(context).size.width;
    return PopScope(
      onPopInvoked: (didPop) {
        Get.delete<FilteredBronzesController>();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Bronzes Geral',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              // fontFamily: 'DancingScript'
            ),
          ),
          centerTitle: true,
        ),
        body: Obx(() { 
          int sumSecs = filteredController.filtered.fold(0, (previousValue, bronze) => previousValue + bronze.totalSecs);
          int totHours = sumSecs ~/ 3600;
          int totMins = sumSecs % 3600 ~/ 60;
          int totSecs = sumSecs % 3600 % 60;
          return GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return SingleChildScrollView(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: getModalOptions(context),
                              ),
                            ),
                          );
                        },
                        backgroundColor: Colors.white,
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          alignment: Alignment.center,
                          width: width * .5,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: const BorderRadius.all(Radius.circular(20))
                          ),
                          margin: EdgeInsets.only(left: width * .05, top: 5, bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: width * .1),
                                child: Obx(() => Text(
                                    filteredController.type.value,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold
                                    ),
                                  )
                                ),
                              ),
                              const Icon(
                                Icons.calendar_month, 
                                size: 20, 
                                color: Colors.black,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: ListView.builder(
                          itemCount: filteredController.filtered.length,
                          itemBuilder: (context, index) {
                            Bronze bronze = filteredController.filtered[index];
                            Client client = clientController.findById(bronze.clientId)!;
                            
                            int hours = bronze.totalSecs ~/ 3600;
                            int mins = bronze.totalSecs % 3600 ~/ 60;
                            int secs = bronze.totalSecs % 3600 % 60;
                            return Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                                margin: const EdgeInsets.all(10),
                                child: ListTile(
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            client.name,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          client.picture !=
                                                  null
                                              ? FittedBox(
                                                  fit: BoxFit.cover,
                                                  child: CircleAvatar(
                                                    backgroundImage: Image.memory(
                                                            client.picture!)
                                                        .image,
                                                    radius: 20,
                                                  ),
                                                )
                                              : const FittedBox(
                                                  fit: BoxFit.cover,
                                                  child: CircleAvatar(
                                                    backgroundColor: Colors.white,
                                                    radius: 20,
                                                    child: Icon(Icons.person_2),
                                                  ),
                                                )
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            bronze.timestamp.day.toString().padLeft(2, '0'),
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          Text(
                                            Validator.getMonthAbbr(bronze.timestamp.month),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          Text(
                                            bronze.timestamp.year.toString(),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold
                                            ),
                                          )
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            FontAwesomeIcons.clock, 
                                            color: Colors.black,
                                          ),
                                          Text(
                                            '${bronze.timestamp.hour.toString().padLeft(2, "0")}:${bronze.timestamp.minute.toString().padLeft(2, "0")}',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold
                                            ),
                                          )
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                                Text(bronze.turnArounds.toString())
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
                                              color: Colors.pink,
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
                                              color: Colors.green,
                                            ),
                                            Text(bronze.price.toStringAsFixed(2))
                                          ],
                                        ),
                                      ),
                                        ],
                                      )
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
                                    if (reportShown.value) {
                                      for (RxBool show in shows) {
                                        show.value = !show.value;
                                      }
                                    } else {
                                      for (RxBool show in shows.reversed) {
                                        show.value = !show.value;
                                      }
                                    }
                                    reportShown.value = !reportShown.value;
                                  },
                                  icon: Icon(reportShown.value ? Icons.arrow_downward : Icons.arrow_upward)
                              )
                            ]),
                        showDependent(box10, shows[0]),
                        showDependent(
                            Row(
                              children: [
                                const Icon(
                                  Icons.sunny,
                                  color: Colors.pink,
                                ),
                                Text(filteredController.filtered.length.toString())
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
                            Text(filteredController.filtered.fold(0, (previousValue, bronze) => previousValue + bronze.turnArounds).toString())
                          ],
                        ), shows[1]),
                        showDependent(box5, shows[2]),
                        showDependent(Row(
                          children: [
                            const Icon(
                              Icons.timer,
                              color: Colors.pink,
                            ),
                            Text("${totHours.toString().padLeft(2, "0")}:${totMins.toString().padLeft(2, "0")}:${totSecs.toString().padLeft(2, "0")}")
                          ],
                        ), shows[2]),
                        showDependent(box5, shows[3]),
                        showDependent(Row(
                          children: [
                            const Icon(
                              Icons.monetization_on,
                              color: Colors.green,
                            ),
                            Text(filteredController.filtered.fold(Decimal.zero, (previousValue, bronze) => previousValue + bronze.price).toStringAsFixed(2))
                          ],
                        ), shows[3])
                      ],
                    ),
                  ))
                ],
              )
      );
    })),
    );
  }
}
