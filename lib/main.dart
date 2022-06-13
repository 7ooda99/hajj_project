

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/route_manager.dart';
import 'package:syrian_hajj_project/firebase_options.dart';
import 'package:syrian_hajj_project/pages/airport_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:syrian_hajj_project/services/local_notification_service.dart';
import 'pages/form_page.dart';
import 'pages/home_page.dart';
import 'pages/hotel_page.dart';
import 'pages/login_page.dart';
import 'pages/mashaaer_page.dart';
import 'pages/register.dart';



Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  (message.data.toString());
  (message.notification!.title);
}

void main() async {
  
  
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
 
  runApp( const Starter());
}

class Starter extends StatefulWidget {
   const Starter({Key? key}) : super(key: key);

  @override
  State<Starter> createState() => _StarterState();
}

class _StarterState extends State<Starter> {
  @override 
  void initState(){
    
    super.initState();

    // LocalNotificationService.initialize(context);

  FirebaseMessaging.instance.getInitialMessage().then((message)
  {
    if(message != null)
    {
      final routeFromMessage = message.data["route"];
      Navigator.of(context).pushNamed(routeFromMessage);
    }
  });
  FirebaseMessaging.onMessage.listen((message) {
    if(message.notification != null)
    {
      (message.notification!.body);
    (message.notification!.title);   
    // LocalNotificationService.display(message);
    }
  },);
  

  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    final routeFromMessage = message.data["route"];
    Navigator.of(context).pushNamed(routeFromMessage);
  },);


  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        LoginPage.id: (context) => const LoginPage(),
        RegisterPage.id: (context) => const RegisterPage(),
        AirportPage.id: (context) => AirportPage(),
        HomePage.id: (context) => const HomePage(),
        FormPage.id: (context) => FormPage(tripid: ''),
        HotelPage.id: (context) => const HotelPage(),
        MashaaerPage.id: (context) => const MashaaerPage(),
      },
      initialRoute: HomePage.id,
    );
  }
}
