import 'package:hive/hive.dart';
import 'package:get/get.dart';
import 'package:agendador_bronzeamento/utils/constants.dart';

@HiveType(typeId: 3)
class BedCard {
  BedCard({
    required this.clientName,
    required this.bedNumber,
    required this.totalDuration,
    required this.remainingTime,
    required this.totalCircles,
    required this.paintedCircles
  });

  @HiveField(0)
  String clientName;

  @HiveField(1)
  int bedNumber;

  @HiveField(2)
  Duration totalDuration;

  @HiveField(3)
  Duration remainingTime;

  @HiveField(4)
  int totalCircles;

  @HiveField(5)
  int paintedCircles;

  @override
  String toString() {
    return '{"clientName" : "$clientName", "bedNumber": "$bedNumber", "paintedCircles": "$paintedCircles"}';
  }

  @override
  bool operator ==(Object other) {
    return other is BedCard && 
            clientName == other.clientName && 
            bedNumber == other.bedNumber;
  }

    @override
  int get hashCode => Object.hash(clientName, bedNumber);
}

class BedCardAdapter extends TypeAdapter<BedCard> {
  @override
  final int typeId = 3;

  @override
  BedCard read(BinaryReader reader) {
    final clientName = reader.read();
    final bedNumber = reader.read();
    final totalDuration = reader.read();
    final remainingTime = reader.read();
    final totalCircles = reader.read();
    final paintedCircles = reader.read();
    return BedCard(
      clientName: clientName, 
      bedNumber: bedNumber,
      totalDuration: Duration(milliseconds: totalDuration),
      remainingTime: Duration(milliseconds: remainingTime),
      totalCircles: totalCircles,
      paintedCircles: paintedCircles 
    );
  }

  @override
  void write(BinaryWriter writer, BedCard obj) {
    writer.write(obj.clientName);
    writer.write(obj.bedNumber);
    writer.write(obj.totalDuration.inMilliseconds);
    writer.write(obj.remainingTime.inMilliseconds);
    writer.write(obj.totalCircles);
    writer.write(obj.paintedCircles);
  }
}

class BedCardController extends GetxController {
  RxList<BedCard> bedCards = <BedCard>[].obs;
  RxBool loaded = false.obs;
  RxInt nextBedCard = 0.obs;

  Future<void> clear() async {
    final Box<BedCard> bedCardsBoxObj = await Hive.openBox<BedCard>(bedCardsBox);
    await bedCardsBoxObj.clear();
    bedCards.clear();
  }
  
  Future<void> fetchBedCards() async {
    final Box<BedCard> bedCardsBoxObj = await Hive.openBox<BedCard>(bedCardsBox);
    loaded.value = true;
    bedCards.value = bedCardsBoxObj.values.toList();
    nextBedCard.value = bedCards.length + 1;
  }

  Future<void> addBedCard(BedCard bedCard, {bool sumNext = true}) async {
    if (findBedCardByClientName(bedCard.clientName) != null) {
      final Box<BedCard> bedCardsBoxObj = await Hive.openBox<BedCard>(bedCardsBox);
      await bedCardsBoxObj.put(bedCard.clientName, bedCard);
      bedCards.add(bedCard);
      if (sumNext) {
        nextBedCard.value++;
      }
    } else {
      throw 'Bed card already exists';
    }
  }

  Future<void> removeBedCard(BedCard bedCard) async {
    final Box<BedCard> bedCardsBoxObj = await Hive.openBox<BedCard>(bedCardsBox);
    await bedCardsBoxObj.delete(bedCard.clientName);
    bedCards.remove(bedCard);
  }

  Future<void> updateBedCard(BedCard oldBedCard, BedCard newBedCard) async {
    await removeBedCard(oldBedCard);
    await addBedCard(newBedCard, sumNext: false);
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