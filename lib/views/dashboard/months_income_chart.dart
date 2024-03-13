import 'package:agendador_bronzeamento/database/models/bronze.dart';
import 'package:agendador_bronzeamento/utils/validator.dart';
import 'package:decimal/decimal.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MonthsIncomeChart extends StatelessWidget {
  const MonthsIncomeChart({super.key});

  @override
  Widget build(context) {
    final BronzeController bronzeController = Get.find();
    List<int> months = <int>[DateTime.now().month];
    for (int i = 1; i < months[months.length - 1]; i++) {
      months.insert(months.length - 1, i);
    }
    List<Decimal> monthsIncome = <Decimal>[];
    for (int month in months) {
      List<Decimal> bronzesPrice = bronzeController.bronzes.where((bronze) => bronze.timestamp.month == month).map((bronze) => bronze.price).toList();
      Decimal result = bronzesPrice.fold(Decimal.zero, (previousValue, element) => previousValue + element);
      monthsIncome.add(result);
    }
    // Sample data to test. 
    // List<int> months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
    // List<Decimal> monthsIncome = [Decimal.parse('12'), Decimal.parse('19'), Decimal.parse('2'), Decimal.parse('1'), Decimal.parse('5'), Decimal.parse('10'), Decimal.parse('7'), Decimal.parse('9'), Decimal.parse('3'), Decimal.parse('4'), Decimal.parse('3'), Decimal.parse('7')];
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 25),
      padding: const EdgeInsets.only(top: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Renda Mensal',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          SizedBox(
            width: width * .9,
            height: height * .6,
            child: Transform.scale(
              scale: .8,
              child: LineChart(
                LineChartData(
                  lineTouchData: LineTouchData(
                    handleBuiltInTouches: true,
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: Colors.black.withOpacity(0.8),
                    ),
                  ),
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                        interval: 1,
                        getTitlesWidget: (value, meta) => SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 10,
                          child: RotationTransition(
                            turns: const AlwaysStoppedAnimation(-0.10),
                            child: Text(
                              Validator.getMonthAbbr(value.toInt()), 
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black
                              )
                            ),
                          ),
                        )
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        getTitlesWidget: (value, meta) {
                          if (monthsIncome.contains(Decimal.parse(value.toString()))) {
                            return Text(
                              value.toString(), 
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                              ), 
                              textAlign: TextAlign.center
                            );
                          }
                          return Container();
                        },
                        interval: 1,
                        showTitles: true,
                        reservedSize: 50,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      bottom: BorderSide(color: Colors.black, width: 1),
                      left: BorderSide(color: Colors.black, width: 1),
                      right: BorderSide(color: Colors.black, width: 1),
                      top: BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      color: Colors.pink,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(show: false),
                      spots: months.map((month) => FlSpot(month.toDouble(), monthsIncome[month - 1].toDouble())).toList()
                    ),
                  ]
                ),
                duration: const Duration(microseconds: 150),
                curve: Curves.easeInOut,
              ),
            ),
          ),
        ],
      ),
    );
  }
}