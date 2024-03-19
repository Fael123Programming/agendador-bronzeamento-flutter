import 'package:agendador_bronzeamento/database/models/config.dart';
import 'package:agendador_bronzeamento/utils/background_service.dart';
import 'package:agendador_bronzeamento/utils/notification_service.dart';
import 'package:agendador_bronzeamento/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:agendador_bronzeamento/database/models/client.dart';
import 'package:agendador_bronzeamento/config/custom_router.dart';
import 'package:agendador_bronzeamento/config/route_paths.dart';
import 'package:agendador_bronzeamento/database/models/bronze.dart';
import 'package:agendador_bronzeamento/views/home.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/bed_card.dart';

// class LifecycleEventHandler extends WidgetsBindingObserver {
//   LifecycleEventHandler({
//     required this.resumeCallBack, 
//     required this.detachedCallBack
//   });

//   final Future<void> Function() resumeCallBack;
//   final Future<void> Function() detachedCallBack;

//  @override
//  Future<bool> didPopRoute()

//  @override
//  void didHaveMemoryPressure()

//   @override
//   Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
//     switch (state) {
//       case AppLifecycleState.inactive:
//       case AppLifecycleState.paused:
//       case AppLifecycleState.detached:
//         await detachedCallBack();
//         break;
//       case AppLifecycleState.resumed:
//         await resumeCallBack();
//         break;
//       default:
//         break;
//     }
//   }
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // WidgetsBinding.instance.addObserver(LifecycleEventHandler(
  //   detachedCallBack: () async {
  //     // print('APP IS GOING TO DIE');
  //   },
  //   resumeCallBack: () async {
  //     // print('WE ARE BACK AGAIN');
  //   }));
  await BackgroundService().init();
  await NotificationService().init();
  final ConfigController configController = Get.put(ConfigController());
  await configController.fetch();
  final ClientController clientController = Get.put(ClientController());
  await clientController.fetch();
  final BronzeController bronzeController = Get.put(BronzeController());
  await bronzeController.fetch();
  Get.put(HomeController());
  Get.put(BedCardListController());
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      onGenerateRoute: CustomRouter.onGenerateRoute,
      initialRoute: RoutePaths.splash
    ),
  );
}
