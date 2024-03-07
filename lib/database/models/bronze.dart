import 'package:agendador_bronzeamento/database/database_helper.dart';
import 'package:decimal/decimal.dart';
import 'package:get/get.dart';

class Bronze {
  final int id;
  final int clientId;
  final int totalSecs;
  final int totalTurns;
  final Decimal price;
  final DateTime timestamp;

  const Bronze({
    required this.id,
    required this.clientId,
    required this.totalSecs,
    required this.totalTurns,
    required this.price,
    required this.timestamp
  });

  static Bronze fromMap(Map<String, dynamic> map) {
    return Bronze(
      id: map['id'],
      clientId: map['clientId'],
      totalSecs: map['totalSecs'],
      totalTurns: map['totalTurns'],
      price: Decimal.parse(map['price']),
      timestamp: DateTime.parse(map['timestamp'])
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'clientId': clientId,
      'totalSecs': totalSecs,
      'totalTurns': totalTurns,
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
    await DatabaseHelper().insertBronze(bronze);
    bronzes.add(bronze);
  }

  List<Bronze> findBronzesOfClient(int clientId) {
    try {
      return bronzes.where((bronze) => bronze.clientId == clientId).toList().reversed.toList();
    } catch(err) {
      return <Bronze>[];
    }
  }
}