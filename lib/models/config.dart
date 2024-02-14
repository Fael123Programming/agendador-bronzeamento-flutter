import 'package:hive/hive.dart';
import 'package:get/get.dart';
import 'package:agendador_bronzeamento/utils/constants.dart';

@HiveType(typeId: 1)
class Config {
  Config({
    this.turnArounds = '0',
    this.defaultHours = '0',
    this.defaultMins = '0',
    this.defaultSecs = '0'
  });

  @HiveField(0)
  String turnArounds;

  @HiveField(1)
  String defaultHours;

  @HiveField(2)
  String defaultMins;

  @HiveField(3)
  String defaultSecs;
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
    return Config(
      turnArounds: turnArounds,
      defaultHours: defaultHours,
      defaultMins: defaultMins,
      defaultSecs: defaultSecs,
    );
  }

  @override
  void write(BinaryWriter writer, Config obj) {
    writer.write(obj.turnArounds);
    writer.write(obj.defaultHours);
    writer.write(obj.defaultMins);
    writer.write(obj.defaultSecs);
  }
}

class ConfigController extends GetxController {
  Rx<Config>? config;
  RxBool loaded = false.obs;

  Future<void> fetchConfig() async {
    Box<Config> box = await Hive.openBox<Config>(appBox);
    Config? c = box.get(configObject);
    if (c == null) {
      c = Config(turnArounds: '4', defaultHours: '0', defaultMins: '40', defaultSecs: '0');
      await box.put(configObject, c);
    }
    loaded = true.obs;
    config = c.obs;
  }
}