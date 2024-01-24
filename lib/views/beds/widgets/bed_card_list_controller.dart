import 'package:agendador_bronzeamento/views/beds/service/bed_card_service.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/bed_card.dart';
import 'package:get/get.dart';

class BedCardListController extends GetxController {
  final RxList<BedCard> bedCards = <BedCard>[].obs;

  @override
  void onInit() {
    super.onInit();
    // List<BedCard> _bedCards = BedCardService.fetchBedCards();
    bedCards.addAll(BedCardService.fetchBedCards());
  }

  // void addBedCard(String clientName, int bedNumber) {
  //   bedCards.add(BedCard(clientName: clientName, bedNumber: bedNumber));
  // }

  void removeCard(int index) {
    bedCards.removeAt(index);
  }

  void dismissCard(int index) {
    bedCards[index].dismissed.value = true;
  }

  void handleEvent(int index) {

  }
}
