import 'package:agendador_bronzeamento/database/models/config.dart';
import 'package:agendador_bronzeamento/utils/background_service.dart';
import 'package:agendador_bronzeamento/utils/notification_service.dart';
import 'package:agendador_bronzeamento/utils/theme.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/bed_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:agendador_bronzeamento/database/models/client.dart';
import 'package:agendador_bronzeamento/config/custom_router.dart';
import 'package:agendador_bronzeamento/config/route_paths.dart';
import 'package:agendador_bronzeamento/database/models/bronze.dart';
import 'package:agendador_bronzeamento/views/home.dart';

Future<void> main() async {
  Get.put(HomeController());
  Get.put(BedCardListController());
  WidgetsFlutterBinding.ensureInitialized();
  await BackgroundService().init();
  await NotificationService().init();
  final ConfigController configController = Get.put(ConfigController());
  await configController.fetch();
  final ClientController clientController = Get.put(ClientController());
  await clientController.fetch();
  final BronzeController bronzeController = Get.put(BronzeController());
  await bronzeController.fetch();
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      onGenerateRoute: CustomRouter.onGenerateRoute,
      initialRoute: RoutePaths.splash
    ),
  );
}
