import 'package:agendador_bronzeamento/models/bed_card.dart';
import 'package:flutter/material.dart';
import 'package:agendador_bronzeamento/config/custom_router.dart';
import 'package:agendador_bronzeamento/config/route_paths.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:agendador_bronzeamento/models/config.dart';
import 'package:agendador_bronzeamento/models/user.dart';
import 'package:get/get.dart';
import 'package:agendador_bronzeamento/views/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  Hive.registerAdapter(ConfigAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(BedCardAdapter());

  Get.put(HomeController());

  final ConfigController configController = Get.put(ConfigController());
  await configController.fetchConfig();

  final UserController userController = Get.put(UserController());
  await userController.fetchUsers();

  final BedCardController bedCardController = Get.put(BedCardController());
  await bedCardController.fetchBedCards();

  runApp(
    const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: CustomRouter.onGenerateRoute,
      initialRoute: RoutePaths.splash,
    ),
  );
}
