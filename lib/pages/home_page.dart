  import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
  import 'package:syrian_hajj_project/core/size_config.dart';
import 'package:syrian_hajj_project/pages/airport_main_page.dart';
import 'package:syrian_hajj_project/pages/airport_page.dart';
import 'package:syrian_hajj_project/pages/hotel_page.dart';
import 'package:syrian_hajj_project/pages/mashaaer_page.dart';
  import 'package:syrian_hajj_project/pages/widgets/main_frame_widget.dart';

  import 'login_page.dart';

  class HomePage extends StatelessWidget {
    const HomePage({Key? key}) : super(key: key);
    static String id = 'HomePage';

    @override
    Widget build(BuildContext context) {
      SizeConfig().init(context);
      return Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(height: 30),
              const Image(
                image: AssetImage("assets/images/syrian_logo.png"),
                height: 180,
              ),
              Column(
                children: [
                  MainFameWidget(
                    onTap: () {
                      Get.to(() => AirportMainPage());
                    },
                    text: 'تفويج المطار',
                    icon: Icons.flight_takeoff_rounded,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 20),
                  MainFameWidget(
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      Get.offAll(() => const LoginPage());
                    },
                    color: Colors.redAccent,
                    text: 'تسجيل الخروج',
                    icon: Icons.logout,
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      );
    }
  }


  // Column(
          //   children: [
          //     SizedBox(height: SizeConfig.screenHeight! * 0.12,),
          //     Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 10),
          //       child: Material(
          //                 shadowColor: Colors.grey,
          //   elevation: 10,
          //   borderRadius: BorderRadius.all(Radius.circular(20)),
          //         child: Container(
          //           decoration: BoxDecoration(
          //           //   border: Border.all(
          //           //   color: kMainColor,
          //           // ),
          //           borderRadius: BorderRadius.all(
          //             Radius.circular(20),
          //           ),
          //           ),
                    
          //           child: CustomButton(
          //             text: 'تفويج المطار',
          //           ),
          //         ),
          //       ),
          //     )
          //   ],
          // ),