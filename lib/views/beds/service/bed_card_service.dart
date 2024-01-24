import 'package:agendador_bronzeamento/views/beds/widgets/bed_card.dart';

class BedCardService {
  static List<BedCard> fetchBedCards() {
    List<BedCard> bedCards = List.empty(growable: true);
    for (int i = 0; i < 10; i++) {
      bedCards.add(BedCard(clientName: 'Cliente ${i + 1}', bedNumber: i + 1));
    }
    return bedCards;
  }
}
