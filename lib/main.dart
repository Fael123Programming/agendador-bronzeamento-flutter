import 'package:agendador_bronzeamento/config/config.dart';
import 'package:agendador_bronzeamento/database/models/client.dart';
import 'package:flutter/material.dart';
import 'package:agendador_bronzeamento/config/custom_router.dart';
import 'package:agendador_bronzeamento/config/route_paths.dart';
import 'package:agendador_bronzeamento/database/models/bronze.dart';
import 'package:agendador_bronzeamento/views/home.dart';
import 'package:get/get.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/bed_card.dart';
import 'package:flutter/widgets.dart';

void main() async {
  ConfigController configController = Get.put(ConfigController());
  await configController.init();

  Get.put(HomeController());

  final ClientController clientController = Get.put(ClientController());
  await clientController.fetch();

  final BronzeController bronzeController = Get.put(BronzeController());
  await bronzeController.fetch();

  Get.put(BedCardListController());

  runApp(
    const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: CustomRouter.onGenerateRoute,
      initialRoute: RoutePaths.splash,
    ),
  );
}
