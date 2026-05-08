import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syrian_hajj_project/core/constants.dart';
import 'package:syrian_hajj_project/core/size_config.dart';
import 'package:syrian_hajj_project/pages/airport_main_page.dart';

import 'login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  static String id = 'HomePage';

  Widget _buildMenuCard({
    required VoidCallback onTap,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_back_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        // backgroundColor: kMainColor,
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        //   backgroundColor: kMainColor,
        //   centerTitle: true,
        //   title: Text(
        //     'لجنة الحج العليا السورية',
        //     style: TextStyle(color: Colors.black, fontFamily: 'Cairo'),
        //   ),
          // actions: [
          //   IconButton(
          //     onPressed: () {
          //       Navigator.pushNamed(context, LoginPage.id);
          //     },
          //     icon: Icon(
          //       Icons.logout,
          //       color: Colors.black,
          //     ),
          //   ),
          // ],
        // ),
        body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: kSecondaryColor.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Image(
                      image: AssetImage("assets/images/logo.png"),
                      height: 160,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'لجنة الحج العليا السورية',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'نظام إدارة التفويج',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildMenuCard(
                    onTap: () => Get.to(() => AirportMainPage()),
                    icon: Icons.flight_land_sharp,
                    title: 'تفويج المطار',
                    subtitle: 'إدارة رحلات المطار والباصات',
                    color: kSecondaryColor,
                  ),
                  const SizedBox(height: 16),
                  _buildMenuCard(
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      Get.to(() => const LoginPage());
                    },
                    icon: Icons.logout,
                    title: 'تسجيل الخروج',
                    subtitle: 'الخروج من الحساب الحالي',
                    color: Colors.redAccent,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
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