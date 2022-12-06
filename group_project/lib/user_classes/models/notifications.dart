import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart';

/*
  * Class which handles the notification requests of the user. This is used
  * primarily in the password reset function. This would send the user a "now"
  * notification telling them to fill out a form and a "later" notification
  * to remind them that if an email has not been sent please check your spam
  * folder or resend a request.
  * */
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

  /*
  * Function that works asynchronously to check notification status
  * */
  Future onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async{
    if (notificationResponse != null){
      print("onDidReceiveNotificationResponse::payload = ${notificationResponse.payload}");
    }
  }

  /*
  * Function that sends a notification at the current
  * time to the user, asking them to fill the form
  * */
  void sendNotificationNow(String title, String body){
    print(_flutterLocalNotificationsPlugin.toString());
    _flutterLocalNotificationsPlugin.show(_notificationID++, title, body, _platformChannelInfo);
  }

  /*
  * Function that sends a notification two minutes later
  * reminding the user to check their email and if not received to resend
  * the password request.
  * */
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