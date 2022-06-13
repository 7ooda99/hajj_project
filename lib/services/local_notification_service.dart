// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class LocalNotificationService {

//   static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
      
//   // static String? channelDescription = "this is our channel";
//   static void initialize(BuildContext context ) {
//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//             android: AndroidInitializationSettings("assets/images/logo.png"));
//     flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (String? route)async{
//       if (route != null)
//       {
//         Navigator.of(context).pushNamed(route);
//       }
//     });
//   }

//   static void display(RemoteMessage message) async {
//     try {
//       final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
//       const NotificationDetails notificationDetails = NotificationDetails(
//           android: AndroidNotificationDetails(
//         "easyapproach",
//         "easyapproach channel",
//         channelDescription:"this is our channel",
//         importance: Importance.max,
//         priority: Priority.high,
//       ));
      
//       await flutterLocalNotificationsPlugin.show(
//         id,
//         message.notification!.title,
//         message.notification!.body,
//         notificationDetails,
//         payload: message.data['route']
//       );
//     } on Exception catch (e) {
//       print(e);
//     }
//   }
// }
