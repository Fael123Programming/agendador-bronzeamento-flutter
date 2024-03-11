import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:agendador_bronzeamento/config/config.dart';
import 'package:agendador_bronzeamento/database/models/client.dart';
import 'package:agendador_bronzeamento/config/custom_router.dart';
import 'package:agendador_bronzeamento/config/route_paths.dart';
import 'package:agendador_bronzeamento/database/models/bronze.dart';
import 'package:agendador_bronzeamento/views/home.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/bed_card.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> main() async {
  // sqfliteFfiInit();
  // databaseFactory = databaseFactoryFfi;
  WidgetsFlutterBinding.ensureInitialized();

  ConfigController configController = Get.put(ConfigController());
  await configController.init();

  Get.put(HomeController());

  final ClientController clientController = Get.put(ClientController());
  await clientController.fetch();

  final BronzeController bronzeController = Get.put(BronzeController());
  await bronzeController.fetch();
  // await bronzeController.insert(
  //   Bronze.toSave(
  //     clientId: 1, 
  //     totalSecs: 1, 
  //     turnArounds: 1, 
  //     price: Decimal.parse('5'), 
  //     timestamp: DateTime.parse('2023-12-19 10:23:30.100')
  //   )
  // );
  // await bronzeController.insert(
  //   Bronze.toSave(
  //     clientId: 1, 
  //     totalSecs: 1, 
  //     turnArounds: 1, 
  //     price: Decimal.parse('15'), 
  //     timestamp: DateTime.parse('2023-12-25 07:30:10.200')
  //   )
  // );
  // await bronzeController.insert(
  //   Bronze.toSave(
  //     clientId: 1, 
  //     totalSecs: 1, 
  //     turnArounds: 1, 
  //     price: Decimal.parse('17'), 
  //     timestamp: DateTime.parse('2024-01-05 07:00:45.100')
  //   )
  // );
  // await bronzeController.insert(
  //   Bronze.toSave(
  //     clientId: 1, 
  //     totalSecs: 1, 
  //     turnArounds: 1, 
  //     price: Decimal.parse('23'), 
  //     timestamp: DateTime.parse('2024-01-25 09:23:10.321')
  //   )
  // );
  // await bronzeController.insert(
  //   Bronze.toSave(
  //     clientId: 1, 
  //     totalSecs: 1, 
  //     turnArounds: 1, 
  //     price: Decimal.parse('67'), 
  //     timestamp: DateTime.parse('2024-02-10 08:30:20.123')
  //   )
  // );
  // await bronzeController.insert(
  //   Bronze.toSave(
  //     clientId: 1, 
  //     totalSecs: 1, 
  //     turnArounds: 1, 
  //     price: Decimal.parse('40'), 
  //     timestamp: DateTime.parse('2024-02-20 15:20:40.500')
  //   )
  // );

  Get.put(BedCardListController());

  runApp(
    const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: CustomRouter.onGenerateRoute,
      initialRoute: RoutePaths.splash,
    ),
  );
}
