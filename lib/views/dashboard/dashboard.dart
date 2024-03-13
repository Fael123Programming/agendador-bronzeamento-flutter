import 'package:agendador_bronzeamento/views/dashboard/bronzes_chart.dart';
import 'package:agendador_bronzeamento/views/dashboard/clients_chart.dart';
import 'package:agendador_bronzeamento/views/dashboard/months_income_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(context) {
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
              Row(
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
              SingleChildScrollView(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClientsChart(),
                    // Divider(height: 1),
                    BronzesChart(),
                    // Divider(height: 1),
                    MonthsIncomeChart()
                  ],
                ),
              ),
            ],
          ),
        ))
      ),
    );
  }
}