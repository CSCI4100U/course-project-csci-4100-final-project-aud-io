import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart';
import 'dart:io';

class Notifications{

  final channelID = "passwordNotif";
  final channelName = "Password Reset Notifications";
  final channelDescription = "Notification Channel for Password Resets";

  var _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  NotificationDetails? _platformChannelInfo;
  var _notificationID = 100;

  Future init() async{

    var initializationSettingsAndroid = AndroidInitializationSettings('mipmap/ic_launcher');

    var initializationSettingIOS = DarwinInitializationSettings(
        onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload){
          return null;
        }
    );

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingIOS
    );

    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );

    var androidChannelInfo = AndroidNotificationDetails(channelID, channelName, channelDescription: channelDescription);
    var iOSChannelInfo = DarwinNotificationDetails();
    _platformChannelInfo = NotificationDetails(
        android: androidChannelInfo,
        iOS: iOSChannelInfo
    );
  }

  Future onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async{
    if (notificationResponse != null){
      print("onDidReceiveNotificationResponse::payload = ${notificationResponse.payload}");
    }
  }

  void sendNotificationNow(String title, String body){
    print(_flutterLocalNotificationsPlugin.toString());
    _flutterLocalNotificationsPlugin.show(_notificationID++, title, body, _platformChannelInfo);
  }

  scheduleNotificationLater(String title, String body, TZDateTime when){
    return _flutterLocalNotificationsPlugin.zonedSchedule(
        _notificationID++,
        title,
        body,
        when,
        _platformChannelInfo!,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }
}