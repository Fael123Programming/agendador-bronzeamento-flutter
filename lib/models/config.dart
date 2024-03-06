import 'package:hive/hive.dart';
import 'package:get/get.dart';
import 'package:agendador_bronzeamento/utils/constants.dart';

@HiveType(typeId: 1)
class Config {
  Config({
    this.turnArounds = '4',
    this.defaultHours = '0',
    this.defaultMins = '40',
    this.defaultSecs = '0',
    this.defaultPrice = '90.00',
    this.sortBy = 'name',
    this.increasing = true
  });

  @HiveField(0)
  String turnArounds;

  @HiveField(1)
  String defaultHours;

  @HiveField(2)
  String defaultMins;

  @HiveField(3)
  String defaultSecs;

  @HiveField(4)
  String defaultPrice;

  @HiveField(5)
  String sortBy;

  @HiveField(6)
  bool increasing;
}

class ConfigAdapter extends TypeAdapter<Config> {
  @override
  final int typeId = 1;
  
  @override
  Config read(BinaryReader reader) {
    final turnArounds = reader.read();
    final defaultHours = reader.read();
    final defaultMins = reader.read();
    final defaultSecs = reader.read();
    final defaultPrice = reader.read();
    final sortBy = reader.read();
    final increasing = reader.read();
    return Config(
      turnArounds: turnArounds,
      defaultHours: defaultHours,
      defaultMins: defaultMins,
      defaultSecs: defaultSecs,
      defaultPrice: defaultPrice,
      sortBy: sortBy,
      increasing: increasing
    );
  }

  @override
  void write(BinaryWriter writer, Config obj) {
    writer.write(obj.turnArounds);
    writer.write(obj.defaultHours);
    writer.write(obj.defaultMins);
    writer.write(obj.defaultSecs);
    writer.write(obj.defaultPrice);
    writer.write(obj.sortBy);
    writer.write(obj.increasing);
  }
}

class ConfigController extends GetxController {
  Rx<Config> config = Config().obs;
  RxBool loaded = false.obs;

  Future<void> fetchConfig() async {
    Box<Config> box = await Hive.openBox<Config>(appBox);
    Config? c = box.get(configObject);
    if (c == null) {
      c = Config();
      await box.put(configObject, c);
    }
    loaded.value = true;
    config.value = c;
    await box.close();
  }

  Future<void> updateConfig({
    String? turnArounds, 
    String? hours, 
    String? mins, 
    String? secs, 
    String? price,
    String? sortBy,
    bool? increasing
  }) async {
    Box<Config> box = await Hive.openBox<Config>(appBox);
    Config? c = box.get(configObject);
    if (c == null) {
      c = Config(
        turnArounds: turnArounds ?? '4',
        defaultHours: hours ?? '0',
        defaultMins: mins ?? '40',
        defaultSecs: secs ?? '0',
        defaultPrice: price ?? '90',
        sortBy: sortBy ?? 'name',
        increasing: increasing ?? true
      );
    } else {
      c = Config(
        turnArounds: turnArounds ?? config.value.turnArounds,
        defaultHours: hours ?? config.value.defaultHours,
        defaultMins: mins ?? config.value.defaultMins,
        defaultSecs: secs ?? config.value.defaultSecs,
        defaultPrice: price ?? config.value.defaultPrice,
        sortBy: sortBy ?? config.value.sortBy,
        increasing: increasing ?? config.value.increasing
      );
    }
    await box.put(configObject, c);
    await box.close();
    config.value = c;
  }
}