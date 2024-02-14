// import 'package:agendador_bronzeamento/views/beds/service/bed_card_service.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/bed_card.dart';
import 'package:get/get.dart';

class BedCardListController extends GetxController {
  RxList<BedCard> bedCards = <BedCard>[].obs;
  var bedCardsToRemove = <BedCard>[].obs;

  // @override
  // void onInit() {
    // super.onInit();
    // bedCards.addAll(BedCardService.fetchBedCards(this));
  // }

  void add(BedCard card) {
    bedCards.add(card);
  }

  BedCard? findBedCardByClientName(String clientName) {
    try {
      return bedCards.where((card) => card.clientName == clientName).first;
    } catch(err) {
      return null;
    }
  }

  bool removeCardByClientName(String clientName) {
    return bedCards.remove(findBedCardByClientName(clientName));
  }
}
