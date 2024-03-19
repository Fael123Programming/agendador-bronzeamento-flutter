import 'dart:async';
import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

class BackgroundService {
  static const notificationChannelId = 'Background Service Channel Id';
  static const notificationId = 888;
  static const serviceTitle = 'Seu app de bronzeamento está rodando';
  static const serviceBody = 'Coloque uma cliente em uma maca...';

  static final BackgroundService _backgroundService = BackgroundService._internal();

  factory BackgroundService() {
    return _backgroundService;
  }

  BackgroundService._internal();

  static Future<void> onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    Timer.periodic(const Duration(hours: 1), (timer) async {
      if (service is AndroidServiceInstance) {
        if (await service.isForegroundService()) {
          await flutterLocalNotificationsPlugin.show(
            notificationId,
            serviceTitle,
            serviceBody,
            const NotificationDetails(
              android: AndroidNotificationDetails(
                notificationChannelId,
                'Background Service Channel',
                icon: 'ic_bg_service_small',
                ongoing: true,
              ),
            ),
          );
        }
      }
    });
  }

  Future<void> init() async {
    final service = FlutterBackgroundService();
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      notificationChannelId,
      'Background Service Channel',
      description: 'Service to run the app in the background',
      importance: Importance.high,
    );
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true,
        notificationChannelId: notificationChannelId,
        initialNotificationTitle: serviceTitle,
        initialNotificationContent: serviceBody,
        foregroundServiceNotificationId: notificationId,
      ),
      iosConfiguration: IosConfiguration()
    );
  }

  Future<void> kill() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.cancel(notificationId);
  }
}