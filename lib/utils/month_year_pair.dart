import 'package:agendador_bronzeamento/utils/validator.dart';

class MonthYearPair implements Comparable<MonthYearPair> {
  late int month, year;

  MonthYearPair({required this.month, required this.year});

  MonthYearPair.fromString(String toParse) {
    List<String> toParseSplit = toParse.split(' ');
    month = Validator.getMonthNumber(toParseSplit[0]);
    year = int.parse(toParseSplit[2]);
  }

  @override
  String toString() {
    return '${Validator.getMonthAbbr(month)} de $year';
  }

  @override
  bool operator ==(Object other) {
    return other is MonthYearPair && month == other.month && year == other.year;
  }

  @override
  int get hashCode => Object.hash(month, year);

  @override
  int compareTo(MonthYearPair other) {
    int cmpYear = year.compareTo(other.year);
    if (cmpYear == 0) {
      return month.compareTo(other.month);
    }
    return cmpYear;
  }
}