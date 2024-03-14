import 'package:agendador_bronzeamento/database/models/bronze.dart';
import 'package:agendador_bronzeamento/views/dashboard/bronzes_chart.dart';
import 'package:agendador_bronzeamento/views/dashboard/clients_chart.dart';
import 'package:agendador_bronzeamento/views/dashboard/months_income_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(context) {
    final BronzeController bronzeController = Get.find();
    List<int> years = <int>[];
    years.addAll(bronzeController.bronzes.map((element) => element.timestamp.year).toSet().toList());
    if (years.isEmpty) {
      years.add(DateTime.now().year);
    } else {
      years.sort((e1, e2) => e2.compareTo(e1));
    }
    RxInt chosenYear = DateTime.now().year.obs;
    RxString chosenChart = 'Clientes'.obs;
    double width = MediaQuery.of(context).size.width;
    final ScrollController scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.addListener(() {
          double currOffset = scrollController.offset;
          if (currOffset < width * .5) {
            chosenChart.value = 'Clientes';
          } else if (currOffset < 1.4 * width) {
            chosenChart.value = 'Bronzes';
          } else {
            chosenChart.value = 'Renda';
          }
      });
    });
    return PopScope(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Dashboard',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'DancingScript'
            ),
          ),
        ),
        body: Obx(() => SingleChildScrollView(
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
                            children: getModalOptions(
                              years,
                              chosenYear,
                              context
                            ),
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
                                chosenYear.value.toString(),
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
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: chosenChart.value == 'Clientes' ? Colors.pink : Colors.white,
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: IconButton(
                        icon: Column(
                          children: [
                            Icon(Icons.person_2, color: chosenChart.value == 'Clientes' ? Colors.white : Colors.pink),
                            Text('Clientes', style: TextStyle(color: chosenChart.value == 'Clientes' ? Colors.white : Colors.black),)
                          ],
                        ),
                        onPressed: () {
                          scrollController.animateTo(
                            0.0, 
                            duration: const Duration(milliseconds: 100), 
                            curve: Curves.easeInOut
                          );
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: chosenChart.value == 'Bronzes' ? Colors.pink : Colors.white,
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: IconButton(
                        icon: Column(
                          children: [
                            Icon(Icons.wb_sunny, color: chosenChart.value == 'Bronzes' ? Colors.white : Colors.pink),
                            Text('Bronzes', style: TextStyle(color: chosenChart.value == 'Bronzes' ? Colors.white : Colors.black),)
                          ],
                        ),
                        onPressed: () {
                          scrollController.animateTo(
                            width * .9, 
                            duration: const Duration(milliseconds: 100), 
                            curve: Curves.easeInOut
                          );
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: chosenChart.value == 'Renda' ? Colors.pink : Colors.white,
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: IconButton(
                        icon: Column(
                          children: [
                            Icon(Icons.monetization_on, color: chosenChart.value == 'Renda' ? Colors.white : Colors.green),
                            Text('Renda', style: TextStyle(color: chosenChart.value == 'Renda' ? Colors.white : Colors.black),)
                          ],
                        ),
                        onPressed: () {
                          scrollController.animateTo(
                            width * .9 * 2, 
                            duration: const Duration(milliseconds: 100), 
                            curve: Curves.easeInOut
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClientsChart(year: chosenYear.value),
                    BronzesChart(year: chosenYear.value),
                    MonthsIncomeChart(year: chosenYear.value)
                  ],
                )),
              ),
            ],
          ),
        ))
      ),
    );
  }

  List<Widget> getModalOptions(
    List<int> years, 
    RxInt chosenYear,
    BuildContext context
  ) {
    List<Widget> options = <Widget>[];
    for (int year in years) {
      options.add(
        Material(
          child: ListTile(
            tileColor: year == chosenYear.value ? const Color.fromARGB(255, 235, 235, 235) : Colors.white,
            title: Text(
              year.toString(),
              style: TextStyle(
                fontWeight: year == chosenYear.value ? FontWeight.bold : FontWeight.normal,
                fontSize: 18
              ),
            ),
            trailing: const Icon(Icons.calendar_month),
            onTap: () {
              Navigator.pop(context);
              if (year != chosenYear.value) {
                chosenYear.value = year;
              }
            },
          ),
        ),
      );
    }
    return options;
  }
}