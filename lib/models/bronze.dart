import 'package:hive/hive.dart';
import 'package:get/get.dart';
import 'package:agendador_bronzeamento/utils/constants.dart';
import 'package:decimal/decimal.dart';

@HiveType(typeId: 5)
class Bronze {
  Bronze({
    required this.clientName,
    required this.totalDuration,
    required this.totalTurns,
    required this.price,
    required this.timestamp
  });

  @HiveField(0)
  String clientName;

  @HiveField(1)
  Duration totalDuration;

  @HiveField(2)
  int totalTurns;
  
  @HiveField(3)
  Decimal price;

  @HiveField(4)
  DateTime timestamp;

  @override
  String toString() {
    return '{"clientName" : "$clientName", "totalDuration": "$totalDuration", "totalTurns": "$totalTurns", "price": "${price.toString()}", "timestamp": "${timestamp.toString()}"}';
  }

  @override
  bool operator ==(Object other) {
    return other is Bronze && 
            clientName == other.clientName &&
            totalDuration == other.totalDuration &&
            totalTurns == other.totalTurns &&
            price == other.price &&
            timestamp == other.timestamp;
  }

    @override
  int get hashCode => Object.hash(clientName, totalDuration, totalTurns, price, timestamp);
}

class BronzeAdapter extends TypeAdapter<Bronze> {
  @override
  final int typeId = 5;

  @override
  Bronze read(BinaryReader reader) {
    final clientName = reader.read();
    final totalDuration = Duration(milliseconds: reader.read());
    final totalTurns = reader.read();
    final price = Decimal.parse(reader.read());
    final timestamp = DateTime.parse(reader.read());
    return Bronze(
      clientName: clientName, 
      totalDuration: totalDuration,
      totalTurns: totalTurns,
      price: price,
      timestamp: timestamp
    );
  }

  @override
  void write(BinaryWriter writer, Bronze obj) {
    writer.write(obj.clientName);
    writer.write(obj.totalDuration.inMilliseconds);
    writer.write(obj.totalTurns);
    writer.write(obj.price.toString());
    writer.write(obj.timestamp.toString());
  }
}

class BronzeController extends GetxController {
  RxList<Bronze> bronzes = <Bronze>[].obs;
  RxBool loaded = false.obs;

  Future<void> clear() async {
    final Box<Bronze> bronzeBoxObj = await Hive.openBox<Bronze>(bronzeBox);
    await bronzeBoxObj.clear();
    bronzes.clear();
  }
  
  Future<void> fetchBronzes() async {
    final Box<Bronze> bronzeBoxObj = await Hive.openBox<Bronze>(bronzeBox);
    loaded.value = true;
    bronzes.value = bronzeBoxObj.values.toList();
  }

  Future<void> addBronze(Bronze bronze) async {
    final Box<Bronze> bronzesBoxObj = await Hive.openBox<Bronze>(bronzeBox);
    await bronzesBoxObj.put(bronze.clientName, bronze);
    bronzes.add(bronze);
  }

  List<Bronze>? findBronzesOfClientWithName(String clientName) {
    try {
      return bronzes.where((bronze) => bronze.clientName == clientName).toList();
    } catch(err) {
      return null;
    }
  }
}