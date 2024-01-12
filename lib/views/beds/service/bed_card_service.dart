import 'package:agendador_bronzeamento/views/beds/widgets/bed_card.dart';

class BedCardService {
  static List<BedCard> fetchBedCards() {
    List<BedCard> bedCards = List.empty(growable: true);
    for (int i = 0; i < 10; i++) {
      final bedCard = BedCard(
        clientName: 'Mariana Souza Farias: ${i + 1}',
        bedNumber: i + 1,
        onAllBlocksFinished: () {
          final card =
              bedCards.where((element) => element.bedNumber == i + 1).first;
          bedCards.remove(card);
        },
      );
      bedCards.add(bedCard);
    }
    return bedCards;
  }
}
