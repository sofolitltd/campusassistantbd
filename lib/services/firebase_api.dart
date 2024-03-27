import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '/main.dart';
import '/screens/auth/new_home_screen.dart';
import '/screens/community/notice/notice_screen.dart';

//
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  log('Title: ${message.notification!.title}');
}

class FirebaseApi {
  final firebaseMessaging = FirebaseMessaging.instance;

  // local notification
  final channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications',
    importance: Importance.defaultImportance,
  );

  final localNotifications = FlutterLocalNotificationsPlugin();

  //
  Future initLocalPushNotifications() async {
    const android = AndroidInitializationSettings('@drawable/logo');
    const settings = InitializationSettings(android: android);
    await localNotifications.initialize(settings,
        onDidReceiveNotificationResponse: (response) {
      final message = RemoteMessage.fromMap(jsonDecode(response.payload!));
      handleMessage(message);
    });
    final platform = localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(channel);
  }

  //
  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    if (message.data['type'] == 'notice') {
      navigatorKey.currentState?.pushNamed(NoticeScreen.routeName);
    } else {
      navigatorKey.currentState?.pushNamed(NewHomeScreen.routeName);
    }
  }

  //
  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;
      localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: '@drawable/logo',
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );
    });
  }

  // push notifications
  Future<void> initNotifications() async {
    await firebaseMessaging.requestPermission();
    final fcmToken = await firebaseMessaging.getToken();
    log(fcmToken.toString());

    //
    initPushNotifications();

    //
    initLocalPushNotifications();
  }
}
