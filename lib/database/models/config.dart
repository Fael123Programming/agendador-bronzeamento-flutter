import 'package:agendador_bronzeamento/database/database_helper.dart';
import 'package:decimal/decimal.dart';
import 'package:get/get.dart';

class Config {
  late int id;
  int defaultHours;
  int defaultMins;
  int defaultSecs;
  int turnArounds;
  Decimal price;

  Config({
    required this.id, 
    required this.defaultHours, 
    required this.defaultMins, 
    required this.defaultSecs,
    required this.turnArounds,
    required this.price
  });

  Config.toSave({
    required this.defaultHours, 
    required this.defaultMins, 
    required this.defaultSecs,
    required this.turnArounds,
    required this.price
  }) {
    id = -1;
  }

  static Config fromMap(Map<String, dynamic> map) {
    return Config(
      id: map['id'],
      defaultHours: map['defaultHours'],
      defaultMins: map['defaultMins'],
      defaultSecs: map['defaultSecs'],
      turnArounds: map['turnArounds'],
      price: Decimal.parse(map['price'])
    );
  }

  Map<String, Object?> toMap() {
    return {
      'defaultHours': defaultHours,
      'defaultMins': defaultMins,
      'defaultSecs': defaultSecs,
      'turnArounds': turnArounds,
      'price': price.toString()
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }

  @override
  bool operator ==(Object other) {
    return other is Config && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}

class ConfigController extends GetxController {
  late Rx<Config?> config;

  Future<void> fetch() async {
    config = (await DatabaseHelper().selectConfig()).obs;
  }

  Future<void> assertInit(Function() func) async {
    if (config.value == null) {
      await fetch();
    }
    await func();
  }

  Future<void> updateTurnArounds(int turnArounds) async {
    await assertInit(() async {
      config.value!.turnArounds = turnArounds;
      await DatabaseHelper().updateConfig(config.value!);
    });
  }

  Future<void> updateDefaultHours(int hours) async {
    await assertInit(() async {
      config.value!.defaultHours = hours;
      await DatabaseHelper().updateConfig(config.value!);
    });
  }
  
  Future<void> updateDefaultMins(int mins) async {
    await assertInit(() async {
      config.value!.defaultMins = mins;
      await DatabaseHelper().updateConfig(config.value!);
    });
  }
  
  Future<void> updateDefaultSecs(int secs) async {
    await assertInit(() async {
      config.value!.defaultSecs = secs;
      await DatabaseHelper().updateConfig(config.value!);
    });
  }

  Future<void> updatePrice(Decimal price) async {
    await assertInit(() async {
      config.value!.price = price;
      await DatabaseHelper().updateConfig(config.value!);
    });
  }
}