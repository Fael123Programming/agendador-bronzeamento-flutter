import 'package:hive/hive.dart';
import 'package:get/get.dart';
import 'package:agendador_bronzeamento/utils/constants.dart';

@HiveType(typeId: 1)
class Config {
  Config({
    required this.turnArounds,
    required this.time
  });

  @HiveField(0)
  String turnArounds;

  @HiveField(1)
  String time;
}

Future<Config> fetchConfig() async {
  var box = await Hive.openBox(appBox);
  var config = box.get(configObject);
  if (config == null) {
    var c = Config(turnArounds: '4', time: '10000');
    await box.put(configObject, c);
    return c;
  } else {
    return config;
  }
}

class ConfigController extends GetxController {
  Rx<Config>? configData;

  ConfigController() {
    fetchConfig().then((value) => configData = value.obs);
  }

  bool isDataLoaded() {
    try {
      configData!.value;
      return true;
    } catch(err) {
      return false;
    }
  }
}