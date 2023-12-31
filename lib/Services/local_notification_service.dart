import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart'as tz ;
import 'package:timezone/data/latest.dart' as tz ;

class LocalNotificationService{
  LocalNotificationService();

  final _localNotificationService = FlutterLocalNotificationsPlugin();

  Future<void> intialize() async{
    const AndroidInitializationSettings androidInitializationSettings = 
        AndroidInitializationSettings('@drawable/ic_stat_local_fire_department');

    final InitializationSettings settings = InitializationSettings(android: androidInitializationSettings);

    await _localNotificationService.initialize(
      settings,
      onSelectNotification: onSelectedNotification,
    );
  }

  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
        'channelId',
        'channelName',
      channelDescription: 'description',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
    );
    return const NotificationDetails(android: androidNotificationDetails);
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
})async{
    final details = await _notificationDetails();
    await _localNotificationService.show(id, title, body, details);
  }

  void onDidReceiveLocalNotification(int id, String? title, String?body, String? payload){
    print('id: $id');
  }

  void onSelectedNotification(String? payload){
    print('payload: $payload');
  }
}
