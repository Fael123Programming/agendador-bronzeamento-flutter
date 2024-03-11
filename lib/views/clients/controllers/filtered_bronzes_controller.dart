import 'package:get/get.dart';
import 'package:agendador_bronzeamento/database/models/bronze.dart';
import 'package:agendador_bronzeamento/views/clients/utils/month_year_pair.dart';

class FilteredBronzesController extends GetxController {
  final RxList<Bronze> all = <Bronze>[].obs;
  final RxList<Bronze> filtered = <Bronze>[].obs;
  RxString type = ''.obs;

  void filterAll() {
    type.value = 'Tudo';
    filtered.clear();
    filtered.addAll(all);
  }

  FilteredBronzesController(List<Bronze> initialBronzes) {
    all.addAll(initialBronzes);
    all.sort((b1, b2) => b2.timestamp.compareTo(b1.timestamp));
    filterAll();
  }

  void filterMonthYearPair(MonthYearPair pair) {
    type.value = pair.toString();
    filtered.clear();
    filtered.addAll(all.where((bronze) => bronze.timestamp.month == pair.month && bronze.timestamp.year == pair.year));
  }
}