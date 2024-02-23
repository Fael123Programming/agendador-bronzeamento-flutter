import 'package:flutter/material.dart';
import 'package:agendador_bronzeamento/config/custom_router.dart';
import 'package:agendador_bronzeamento/config/route_paths.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:agendador_bronzeamento/models/config.dart';
import 'package:agendador_bronzeamento/models/user.dart';
import 'package:agendador_bronzeamento/models/timing.dart';
import 'package:agendador_bronzeamento/models/bronze.dart';
import 'package:agendador_bronzeamento/views/home.dart';
import 'package:get/get.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/bed_card.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  Hive.registerAdapter(ConfigAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(TimingAdapter());
  Hive.registerAdapter(BronzeAdapter());

  Get.put(HomeController());

  final ConfigController configController = Get.put(ConfigController());
  await configController.fetchConfig();

  final UserController userController = Get.put(UserController());
  await userController.fetchUsers();

  final TimingsController timingsController = Get.put(TimingsController());
  await timingsController.fetchTimings();

  final BronzeController bronzeController = Get.put(BronzeController());
  await bronzeController.fetchBronzes();

  Get.put(BedCardController());

  runApp(
    const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: CustomRouter.onGenerateRoute,
      initialRoute: RoutePaths.splash,
    ),
  );
}
