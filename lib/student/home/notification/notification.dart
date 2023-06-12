import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class AddNotification extends StatefulWidget {
  const AddNotification({Key? key}) : super(key: key);

  @override
  State<AddNotification> createState() => _AddNotificationState();
}

class _AddNotificationState extends State<AddNotification> {
  TextEditingController username = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  String? mToken = '';

  @override
  void initState() {
    super.initState();

    requestPermission();

    loadFCM();

    listenFCM();

    getToken();

    // FirebaseMessaging.instance.subscribeToTopic("Animal");
  }

  //
  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mToken = token;
      });

      //
      saveToken(token!);
    });
  }

  //
  void saveToken(String token) async {
    var userUid = FirebaseAuth.instance.currentUser!.email;
    await FirebaseFirestore.instance.collection("UserTokens").doc(userUid).set(
      {
        'token': token,
      },
    );
  }

  //
  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  // load
  void loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  // listen
  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              playSound: true,

              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              // icon: 'launch_background',
              icon: '@drawable/logo_black',
            ),
          ),
        );
      }
    });
  }

  // send
  void sendPushMessage(String token, String body, String title) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        // Uri.parse('//https:fcm.googleapis.com/v1/projects/campusassistantbd/messages:send'),
        // 'https://fcm.googleapis.com/v1/projects/campusassistantbd/messages:send'
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAvuYABLU:APA91bEMuMwtcZLkSfTj7wg9cDLowAKVEHjRfkVp2x5PN3m6_cSvnD2TYgoipsOaqgMCvuQ5w65LuhpWbojxDhHiztJWMDRt5U6MrHY8mTuTquxOO46jrtKeQVt0qhCqcwJtoKAaLuDn',

          // 'Authorization': 'Bearer ya29.AIzaSyC6GyOYVB353N2SjORdNaZvKThz8zapfyk';
        },

        //var token =  cXUJwXQ5Q_-p7h0Qjlrk2w:APA91bENK4fikj_RCd3-NZHVGB46q3RLXNXUkUhSDnH4RHmAQ8VBJ1I_VZCbDFYVS_0Dh27EM1mx2Vkz7NYvXDbfmfOQakc5zZQyGel75BcZdQKkOqdr_ooUvccrtLfVyAecza2wCVq5
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{'body': body, 'title': title},
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: username,
                decoration: const InputDecoration(hintText: 'User'),
              ),
              TextFormField(
                controller: title,
                decoration: const InputDecoration(hintText: 'title'),
              ),
              TextFormField(
                controller: body,
                decoration: const InputDecoration(hintText: 'Body'),
              ),

              const SizedBox(height: 16),
              //
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    String name = username.text.trim();
                    String titleText = title.text;
                    String bodyText = body.text;

                    if (name != "") {
                      DocumentSnapshot snap = await FirebaseFirestore.instance
                          .collection("UserTokens")
                          .doc(name)
                          .get();

                      String token = snap['token'];
                      print(token);

                      //
                      sendPushMessage(token, titleText, bodyText);
                    }
                  },
                  child: const Text('Send Notification'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
