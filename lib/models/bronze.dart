import 'package:agendador_bronzeamento/models/user.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';
import 'package:agendador_bronzeamento/utils/constants.dart';
import 'package:decimal/decimal.dart';

@HiveType(typeId: 3)
class Bronze {
  Bronze({
    required this.clientName,
    required this.totalSecs,
    required this.totalTurns,
    required this.price,
    required this.timestamp
  });

  @HiveField(0)
  String clientName;

  @HiveField(1)
  int totalSecs;

  @HiveField(2)
  int totalTurns;
  
  @HiveField(3)
  Decimal price;

  @HiveField(4)
  DateTime timestamp;

  @override
  String toString() {
    return '{"clientName" : "$clientName", "totalSecs": "$totalSecs", "totalTurns": "$totalTurns", "price": "${price.toString()}", "timestamp": "${timestamp.toString()}"}';
  }

  @override
  bool operator ==(Object other) {
    return other is Bronze && 
            clientName == other.clientName &&
            totalSecs == other.totalSecs &&
            totalTurns == other.totalTurns &&
            price == other.price &&
            timestamp == other.timestamp;
  }

    @override
  int get hashCode => Object.hash(clientName, totalSecs, totalTurns, price, timestamp);
}

class BronzeAdapter extends TypeAdapter<Bronze> {
  @override
  final int typeId = 5;

  @override
  Bronze read(BinaryReader reader) {
    final clientName = reader.read();
    final totalSecs = reader.read();
    final totalTurns = reader.read();
    final price = Decimal.parse(reader.read());
    final timestamp = DateTime.parse(reader.read());
    return Bronze(
      clientName: clientName, 
      totalSecs: totalSecs,
      totalTurns: totalTurns,
      price: price,
      timestamp: timestamp
    );
  }

  @override
  void write(BinaryWriter writer, Bronze obj) {
    writer.write(obj.clientName);
    writer.write(obj.totalSecs);
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
    final UserController userController = Get.find();
    User user = userController.findUserByName(bronze.clientName)!;
    await userController.updateUser(
      user, 
      User(
        name: user.name,
        phoneNumber: user.phoneNumber,
        bronzes: user.bronzes + 1,
        timestamp: user.timestamp,
        observations: user.observations,
        profileImage: user.profileImage
      )
    );
  }

  List<Bronze>? findBronzesOfClientWithName(String clientName) {
    try {
      return bronzes.where((bronze) => bronze.clientName == clientName).toList();
    } catch(err) {
      return null;
    }
  }
}