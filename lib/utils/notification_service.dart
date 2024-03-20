import 'package:agendador_bronzeamento/database/models/bronze.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/bed_card.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _notificationService;
  }

  // Future<void> Function()? onActionTapped;

  NotificationService._internal();

  Future<void> receivedNotificationResponse(NotificationResponse response) async {
    String? payload = response.payload;
    // Use the content of the payload (which is the body of the notification)
    // to realize what action should be performed: deletion of the card or next turn around.
    if (payload != null) {
      String lowercased = payload.toLowerCase();
      if (lowercased.contains('bronze') && lowercased.contains('finalizado')) {
        final BedCardListController listController = Get.find();
        final BronzeController bronzeController = Get.find();
        final bedCard = listController.list.where((bedCard) => bedCard.bedCardController.bedNumber == response.id).first;
        listController.list.remove(bedCard);
        await bronzeController.insert(
          Bronze.toSave(
            clientId: bedCard.bedCardController.client.id, 
            totalSecs: bedCard.bedCardController.totalSecs, 
            turnArounds: bedCard.bedCardController.turnArounds, 
            price: Decimal.parse(bedCard.bedCardController.price), 
            timestamp: bedCard.bedCardController.timestamp
          )
        );
      } else if (lowercased.contains('virada') && lowercased.contains('finalizada')) {
        final BedCardListController listController = Get.find();
        final bedCard = listController.list.where((bedCard) => bedCard.bedCardController.bedNumber == response.id).first;
        bedCard.bedCardController.startTimer();
      }
    }
  }

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('drawable/ic_stat_wb_sunny');
    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, 
      iOS: initializationSettingsIOS, 
      macOS: null
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) => (() async => await receivedNotificationResponse(response))()
    );
  }

  Future<void> showNotification({
    required int id,
    required String title, 
    required String body,
    required String actionTitle
  }) async {
    // this.onActionTapped = onActionTapped;
    // await init();
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'Main',
      'Main Channel',
      channelDescription: 'The main channel to show local notifications',
      importance: Importance.high,
      priority: Priority.high,
      actions: [
        AndroidNotificationAction(
          'Notification Action',
          actionTitle,
          showsUserInterface: true
        )
      ]
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics
    );
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: body
    );
  }

  Future<void> cancelNotification(int id) async {
    try {
      await flutterLocalNotificationsPlugin.cancel(id);
    } catch(err) {/** Nothing to do.*/}
  }
}
