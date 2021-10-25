import 'package:firebase_messaging/firebase_messaging.dart';
class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  void initialize(){
    _fcm.getInitialMessage();
    _fcm.subscribeToTopic('Notifications');
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });

  }
}