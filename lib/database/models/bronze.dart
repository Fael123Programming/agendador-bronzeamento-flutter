import 'package:agendador_bronzeamento/database/database_helper.dart';
import 'package:agendador_bronzeamento/database/models/client.dart';
import 'package:decimal/decimal.dart';
import 'package:get/get.dart';

class Bronze {
  late int id;
  final int clientId;
  final int totalSecs;
  final int turnArounds;
  final Decimal price;
  final DateTime timestamp;

  Bronze({
    required this.id,
    required this.clientId,
    required this.totalSecs,
    required this.turnArounds,
    required this.price,
    required this.timestamp
  });

  Bronze.toSave({
    required this.clientId,
    required this.totalSecs,
    required this.turnArounds,
    required this.price,
    required this.timestamp
  }) {
    id = -1;
  }

  static Bronze fromMap(Map<String, dynamic> map) {
    try {
      return Bronze(
        id: map['id'],
        clientId: map['clientId'],
        totalSecs: map['totalSecs'],
        turnArounds: map['turnArounds'],
        price: Decimal.parse(map['price'].toString()),
        timestamp: DateTime.parse(map['timestamp'])
      );
    } catch (e) {
      print(map);
      throw 'Problem my dude';
    }
  }

  Map<String, Object?> toMap() {
    return {
      'clientId': clientId,
      'totalSecs': totalSecs,
      'turnArounds': turnArounds,
      'price': price.toString(),
      'timestamp': timestamp.toString()
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }

  @override
  bool operator ==(Object other) {
    return other is Bronze && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}

class BronzeController extends GetxController {
  RxList<Bronze> bronzes = <Bronze>[].obs;
  RxBool loaded = false.obs;

  Future<void> fetch() async {
    bronzes.value = await DatabaseHelper().selectAllBronzes();
    loaded.value = true;
  }

  Future<void> insert(Bronze bronze) async {
    int id = await DatabaseHelper().insertBronze(bronze);
    bronze.id = id;
    bronzes.add(bronze);
    final ClientController clientController = Get.find();
    Client client = clientController.clients.where((client) => client.id == bronze.clientId).first;
    client.bronzes++;
  }

  List<Bronze> findBronzesOfClient(int clientId) {
    try {
      return bronzes.where((bronze) => bronze.clientId == clientId).toList().reversed.toList();
    } catch(err) {
      return <Bronze>[];
    }
  }

  Future<int> deleteBronzesOfYear(int year) async {
    List<Bronze> bronzesOfYear = bronzes.where((bronze) => bronze.timestamp.year == year).toList();
    if (bronzesOfYear.isEmpty) {
      return -1;
    }
    int result = await DatabaseHelper().deleteBronzes(bronzesOfYear);
    final ClientController clientController = Get.find();
    for (Bronze bronze in bronzesOfYear) {
      bronzes.remove(bronze);
      Client? clientToUpdate = clientController.findById(bronze.clientId);
      if (clientToUpdate != null) {
        clientToUpdate.bronzes.value--;
        clientController.doUpdate(clientToUpdate);
      }
    }
    return result;
  }
}