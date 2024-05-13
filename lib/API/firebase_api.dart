import 'package:firebase_messaging/firebase_messaging.dart';

import '../main.dart';
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}
class FirebaseApi{
  final _firebaseMessaging = FirebaseMessaging.instance ;
  Future<void> initNotifications() async{
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken');
    initPushNotifications();
  }
  void handleMessage(RemoteMessage? message) {
    navigatorKey.currentState?.pushNamed('/history', arguments: message);
  }

  Future<void> initPushNotifications() async {
    try {
      // Retrieve the initial message
      final initialMessage = await FirebaseMessaging.instance.getInitialMessage();

      // Check if initialMessage is not null
      if (initialMessage != null) {
        handleMessage(initialMessage);
      }

      // Listen for messages when the app is open
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        handleMessage(message);
      });
    } catch (e) {
      print("Error initializing push notifications: $e");
    }
  }
}
