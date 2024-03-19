import 'package:agendador_bronzeamento/database/database_helper.dart';
import 'package:get/get.dart';

class Config {
  late int id;
  int defaultHours, defaultMins, defaultSecs, turnArounds;
  String price;

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
      price: map['price'].toString()
    );
  }

  Map<String, Object?> toMap() {
    return {
      'defaultHours': defaultHours,
      'defaultMins': defaultMins,
      'defaultSecs': defaultSecs,
      'turnArounds': turnArounds,
      'price': price
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
  late Rx<Config> _config;
  bool started = false;

  Future<Config> get config async {
    if (started) {
      return _config.value;
    }
    await fetch();
    started = true;
    return _config.value;
  }

  Future<void> fetch() async {
    _config = (await DatabaseHelper().selectConfig()).obs;
  }

  Future<void> updateTurnArounds(int turnArounds) async {
    Config localConfig = await config;
    localConfig.turnArounds = turnArounds;
    await DatabaseHelper().updateConfig(localConfig);
  }

  Future<void> updateDefaultHours(int hours) async {
    Config localConfig = await config;
    localConfig.defaultHours = hours;
    await DatabaseHelper().updateConfig(localConfig);
  }
  
  Future<void> updateDefaultMins(int mins) async {
    Config localConfig = await config;
    localConfig.defaultMins = mins;
    await DatabaseHelper().updateConfig(localConfig);
  }
  
  Future<void> updateDefaultSecs(int secs) async {
    Config localConfig = await config;
    localConfig.defaultSecs = secs;
    await DatabaseHelper().updateConfig(localConfig);
  }

  Future<void> updatePrice(String price) async {
    Config localConfig = await config;
    localConfig.price = price;
    await DatabaseHelper().updateConfig(localConfig);
  }
}