import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syrian_hajj_project/core/constants.dart';
import 'package:syrian_hajj_project/core/size_config.dart';
import 'package:syrian_hajj_project/pages/airport_main_page.dart';
import 'package:syrian_hajj_project/pages/widgets/main_frame_widget.dart';

import 'login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  static String id = 'HomePage';

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              kSecondaryColor.withOpacity(0.08),
              Colors.white,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.35, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Logo with subtle glow
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: kMainColor.withOpacity(0.3),
                      blurRadius: 40,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Image(
                  image: AssetImage("assets/images/syrian_logo.png"),
                  height: 160,
                ),
              ),

              const SizedBox(height: 16),

              // Welcome text
              Text(
                'مرحباً بك',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: kSecondaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'نظام إدارة تفويج الحجاج',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),

              const Spacer(),

              // Action buttons
              MainFameWidget(
                onTap: () {
                  Get.to(() => AirportMainPage());
                },
                text: 'تفويج المطار',
                icon: Icons.flight_takeoff_rounded,
                color: kSecondaryColor,
              ),
              const SizedBox(height: 20),
              MainFameWidget(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Get.offAll(() => const LoginPage());
                },
                color: const Color(0xffD64545),
                text: 'تسجيل الخروج',
                icon: Icons.logout_rounded,
              ),

              const SizedBox(height: 50),

              // App version
              Text(
                'v1.0.0',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 11,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}