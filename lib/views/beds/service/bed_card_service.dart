import 'package:agendador_bronzeamento/views/beds/widgets/bed_card.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/bed_card_list_controller.dart';

class BedCardService {
  static List<BedCard> fetchBedCards(BedCardListController controller) {
    List<BedCard> bedCards = List.empty(growable: true);
    for (int i = 0; i < 5; i++) {
      bedCards.add(
        BedCard(
          clientName: 'Cliente ${i + 1}', 
          bedNumber: i + 1
        )
      );
    }
    return bedCards;
  }
}
