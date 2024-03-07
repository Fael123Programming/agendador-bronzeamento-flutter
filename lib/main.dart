import 'package:flutter/material.dart';
import 'package:agendador_bronzeamento/config/custom_router.dart';
import 'package:agendador_bronzeamento/config/route_paths.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:agendador_bronzeamento/database/models/config.dart';
import 'package:agendador_bronzeamento/database/models/client.dart';
import 'package:agendador_bronzeamento/database/models/bronze.dart';
import 'package:agendador_bronzeamento/views/home.dart';
import 'package:get/get.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/bed_card.dart';
import 'package:flutter/widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  // await Hive.initFlutter();

  Hive.registerAdapter(ConfigAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(BronzeAdapter());

  Get.put(HomeController());

  final ConfigController configController = Get.put(ConfigController());
  await configController.fetchConfig();

  final UserController userController = Get.put(UserController());
  await userController.fetchUsers();

  final BronzeController bronzeController = Get.put(BronzeController());
  await bronzeController.fetchBronzes();

  Get.put(BedCardListController());

  runApp(
    const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: CustomRouter.onGenerateRoute,
      initialRoute: RoutePaths.splash,
    ),
  );
}
