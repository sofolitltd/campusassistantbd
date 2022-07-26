import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/headline.dart';
import '/screens/home/widgets/header.dart';
import '/screens/home/widgets/notification_badge.dart';
import '../../models/user_model.dart';
import 'components/categories.dart';
import 'components/custom_drawer.dart';
import 'notice/notice_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  UserModel? userModel;
  // late AndroidNotificationChannel channel;
  // late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  // @override
  // void initState() {
  //   super.initState();
  //
  //   requestPermission();
  //
  //   loadFCM();
  //
  //   listenFCM();
  // }

  @override
  Widget build(BuildContext context) {
    //for automatic keep alive
    super.build(context);

    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text.rich(
          TextSpan(
            text: 'CAMPUS ',
            children: [
              TextSpan(
                text: 'ASSISTANT',
                style: TextStyle(
                  color: Color(0xFFf69520),
                ),
              )
            ],
          ),
          style: TextStyle(
            letterSpacing: 1,
            fontWeight: FontWeight.bold,
            color: Color(0xff6dc7b2),
          ),
          // maxLines: 1,
        ),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              //
              IconButton(
                onPressed: () {
                  //
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NoticeScreen(
                                userModel: userModel!,
                              )));
                },
                icon: const Icon(
                  Icons.notifications_outlined,
                  size: 28,
                ),
              ),

              //  Notification Badge
              const Positioned(
                top: 5,
                right: 2,
                child: NotificationBadge(),
              ),
            ],
          ),
          const SizedBox(width: 12),
        ],
      ),
      drawer: width < 600 ? const CustomDrawer() : null,

      //
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(context,
      //         MaterialPageRoute(builder: (context) => const AddNotification()));
      //   },
      //   child: const Icon(Icons.add),
      // ),

      //
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something wrong!'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          var data = snapshot.data;
          userModel = UserModel.fromJson(data!);

          return ListView(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width > 1000
                  ? MediaQuery.of(context).size.width * .2
                  : 12,
              vertical: 12,
            ),
            children: [
              // header
              Header(userName: userModel!.name),

              const SizedBox(height: 16),

              // categories
              Categories(userModel: userModel!),

              //syllabus links
              // Syllabus(),
            ],
          );
        },
      ),
    );
  }

  //
  // void requestPermission() async {
  //   FirebaseMessaging messaging = FirebaseMessaging.instance;
  //
  //   NotificationSettings settings = await messaging.requestPermission(
  //     alert: true,
  //     announcement: false,
  //     badge: true,
  //     carPlay: false,
  //     criticalAlert: false,
  //     provisional: false,
  //     sound: true,
  //   );
  //
  //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //     print('User granted permission');
  //   } else if (settings.authorizationStatus ==
  //       AuthorizationStatus.provisional) {
  //     print('User granted provisional permission');
  //   } else {
  //     print('User declined or has not accepted permission');
  //   }
  // }
  //
  // // load
  // void loadFCM() async {
  //   if (!kIsWeb) {
  //     channel = const AndroidNotificationChannel(
  //       'high_importance_channel', // id
  //       'High Importance Notifications', // title
  //       importance: Importance.high,
  //       enableVibration: true,
  //     );
  //
  //     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  //
  //     /// Create an Android Notification Channel.
  //     ///
  //     /// We use this channel in the `AndroidManifest.xml` file to override the
  //     /// default FCM channel to enable heads up notifications.
  //     await flutterLocalNotificationsPlugin
  //         .resolvePlatformSpecificImplementation<
  //             AndroidFlutterLocalNotificationsPlugin>()
  //         ?.createNotificationChannel(channel);
  //
  //     /// Update the iOS foreground notification presentation options to allow
  //     /// heads up notifications.
  //     await FirebaseMessaging.instance
  //         .setForegroundNotificationPresentationOptions(
  //       alert: true,
  //       badge: true,
  //       sound: true,
  //     );
  //   }
  // }
  //
  // // listen
  // void listenFCM() async {
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     RemoteNotification? notification = message.notification;
  //     AndroidNotification? android = message.notification?.android;
  //     if (notification != null && android != null && !kIsWeb) {
  //       flutterLocalNotificationsPlugin.show(
  //         notification.hashCode,
  //         notification.title,
  //         notification.body,
  //         NotificationDetails(
  //           android: AndroidNotificationDetails(
  //             channel.id,
  //             channel.name,
  //             playSound: true,
  //
  //             // TODO add a proper drawable resource to android, for now using
  //             //      one that already exists in example app.
  //             // icon: 'launch_background',
  //             icon: '@drawable/logo_black',
  //           ),
  //         ),
  //       );
  //     }
  //   });
  // }
}

//
//
// class AddNotification extends StatefulWidget {
//   const AddNotification({Key? key}) : super(key: key);
//
//   @override
//   State<AddNotification> createState() => _AddNotificationState();
// }
//
// class _AddNotificationState extends State<AddNotification> {
//   TextEditingController username = TextEditingController();
//   TextEditingController title = TextEditingController();
//   TextEditingController body = TextEditingController();
//   late AndroidNotificationChannel channel;
//   late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//
//   String? mToken = '';
//
//   @override
//   void initState() {
//     super.initState();
//
//     requestPermission();
//
//     loadFCM();
//
//     listenFCM();
//
//     getToken();
//
//     // FirebaseMessaging.instance.subscribeToTopic("Animal");
//   }
//
//   //
//   void getToken() async {
//     await FirebaseMessaging.instance.getToken().then((token) {
//       setState(() {
//         mToken = token;
//       });
//
//       //
//       saveToken(token!);
//     });
//   }
//
//   //
//   void saveToken(String token) async {
//     var userUid = FirebaseAuth.instance.currentUser!.email;
//     await FirebaseFirestore.instance.collection("UserTokens").doc(userUid).set(
//       {
//         'token': token,
//       },
//     );
//   }
//
//   //
//   void requestPermission() async {
//     FirebaseMessaging messaging = FirebaseMessaging.instance;
//
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('User granted permission');
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       print('User granted provisional permission');
//     } else {
//       print('User declined or has not accepted permission');
//     }
//   }
//
//   // load
//   void loadFCM() async {
//     if (!kIsWeb) {
//       channel = const AndroidNotificationChannel(
//         'high_importance_channel', // id
//         'High Importance Notifications', // title
//         importance: Importance.high,
//         enableVibration: true,
//       );
//
//       flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//       /// Create an Android Notification Channel.
//       ///
//       /// We use this channel in the `AndroidManifest.xml` file to override the
//       /// default FCM channel to enable heads up notifications.
//       await flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<
//               AndroidFlutterLocalNotificationsPlugin>()
//           ?.createNotificationChannel(channel);
//
//       /// Update the iOS foreground notification presentation options to allow
//       /// heads up notifications.
//       await FirebaseMessaging.instance
//           .setForegroundNotificationPresentationOptions(
//         alert: true,
//         badge: true,
//         sound: true,
//       );
//     }
//   }
//
//   // listen
//   void listenFCM() async {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;
//       if (notification != null && android != null && !kIsWeb) {
//         flutterLocalNotificationsPlugin.show(
//           notification.hashCode,
//           notification.title,
//           notification.body,
//           NotificationDetails(
//             android: AndroidNotificationDetails(
//               channel.id,
//               channel.name,
//               playSound: true,
//
//               // TODO add a proper drawable resource to android, for now using
//               //      one that already exists in example app.
//               // icon: 'launch_background',
//               icon: '@drawable/logo_black',
//             ),
//           ),
//         );
//       }
//     });
//   }
//
//   // send
//   void sendPushMessage(String token, String body, String title) async {
//     try {
//       await http.post(
//         Uri.parse('https://fcm.googleapis.com/fcm/send'),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization':
//               'key=AAAASdoJHIY:APA91bGsG2MPE-OASD4rq-YGpbdoVE_8HnVsC_hOPxStioi2WoPXVVOvC0vJqxRBP9UHFbSeIATgCSmAcGBZKQg_z2Gr2Ia4-HqKTHaYCavsD0Z0lAAUYPzMKUAc8v2nelf-HuU1tWqK',
//         },
//         body: jsonEncode(
//           <String, dynamic>{
//             'notification': <String, dynamic>{'body': body, 'title': title},
//             'priority': 'high',
//             'data': <String, dynamic>{
//               'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//               'id': '1',
//               'status': 'done'
//             },
//             "to": token,
//           },
//         ),
//       );
//     } catch (e) {
//       print("error push notification");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               TextFormField(
//                 controller: username,
//                 decoration: const InputDecoration(hintText: 'User'),
//               ),
//               TextFormField(
//                 controller: title,
//                 decoration: const InputDecoration(hintText: 'title'),
//               ),
//               TextFormField(
//                 controller: body,
//                 decoration: const InputDecoration(hintText: 'Body'),
//               ),
//
//               const SizedBox(height: 16),
//               //
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () async {
//                     String name = username.text.trim();
//                     String titleText = title.text;
//                     String bodyText = body.text;
//
//                     if (name != "") {
//                       DocumentSnapshot snap = await FirebaseFirestore.instance
//                           .collection("UserTokens")
//                           .doc(name)
//                           .get();
//
//                       String token = snap['token'];
//                       print(token);
//
//                       //
//                       sendPushMessage(token, titleText, bodyText);
//                     }
//                   },
//                   child: const Text('Send Notification'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
