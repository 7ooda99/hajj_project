  import 'package:flutter/material.dart';
import 'package:get/get.dart';
  import 'package:syrian_hajj_project/core/size_config.dart';
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
        body: Column(
          children: [
            SizedBox(
              height: SizeConfig.screenHeight! * 0.10,
            ),
            const Image(
                  image: AssetImage(
                    "assets/images/logo.png",
                  ),
                  height: 200,
                ),
                SizedBox(
              height: SizeConfig.screenHeight! * 0.10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MainFameWidget(
                  onTap: ()
                  {
                    Get.to(()=> const HotelPage());
                  },
                  text: 'تفويج الفنادق',
                  icon: const Icon(Icons.hotel),
                ),
                MainFameWidget(
                  onTap: ()
                  {
                    Get.to(()=> AirportPage());
                  },
                  text: 'تفويج المطار',
                  icon: const Icon(Icons.flight_land_sharp),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MainFameWidget(
                  onTap: ()
                  {
                    Get.to(()=> const LoginPage());
                  },
                  color: Colors.red,
                  text: 'تسجيل الخروج',
                  icon: const Icon(Icons.logout, color: Colors.red,),
                ),
                MainFameWidget(
                  onTap: ()
                  {
                    Get.to(()=> const MashaaerPage());
                  },
                  text: 'تفويج المشاعر',
                  icon: const Icon(Icons.home),
                ),
              ],
            )
          ],
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