

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:syrian_hajj_project/core/constants.dart';
import 'dart:ui' as ui;
import 'package:syrian_hajj_project/helper/show_snack_bar.dart';
import 'package:syrian_hajj_project/pages/airport_main_page.dart';
import 'package:syrian_hajj_project/pages/deana_form_page.dart';

import 'package:syrian_hajj_project/pages/form_page.dart';

import 'package:intl/intl.dart';
import '../core/size_config.dart';

class AirportPage extends StatefulWidget {
  final String? tripName;
  final String? tripid;


  AirportPage({Key? key,  this.tripName, this.tripid, }) : super(key: key);

  static String id = 'AirportPage';


  @override
  State<AirportPage> createState() => _AirportPageState();

}


class _AirportPageState extends State<AirportPage> {
  CollectionReference formInfo =
      FirebaseFirestore.instance.collection(kMessagesCollections);
  int selectedValue = 0;
  late Stream<QuerySnapshot> itemStream;
   String tripType = 'bus';
  @override
  void initState() {
    super.initState();
    itemStream = getStreamBasedOnSelection(selectedValue ); // Initialize with default stream
  }
  // final String ttripid=
  final bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    print('the trip name is: ${widget.tripid}');
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Get.off(() => AirportMainPage()),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        backgroundColor: kMainColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'رحلة ${widget.tripName}',
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body:

           Column(
            children: [
               // if ( tripType == 'bus')

              Container(
                margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: CustomSlidingSegmentedControl<int>(
                  innerPadding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(14),
                  ),
                  fixedWidth: SizeConfig.defaultSize! * 18,
                  thumbDecoration: BoxDecoration(
                    color: kSecondaryColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: kSecondaryColor.withOpacity(0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  initialValue: 1,
                  children: const {
                    0: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.local_taxi, size: 16),
                        SizedBox(width: 4),
                        Text('دينات', style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w600,
                        )),
                      ],
                    ),
                    1: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.directions_bus, size: 16),
                        SizedBox(width: 4),
                        Text('باصات', style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w600,
                        )),
                      ],
                    ),
                  },
                  onValueChanged: (int value) {
                    setState(() {
                      selectedValue = value;
                      tripType = value == 0 ? 'deana' : 'bus';
                    });
                  },
                ),
              ),
              Expanded(child: allcards(context, tripType)),
            ],
          ),


      floatingActionButton:buildSpeedDial(),
      // FloatingActionButton(
      //   onPressed: () {
      //     Get.to(
      //         () => FormPage(
      //               tripid: '',
      //               title: 'إضافة رحلة جديدة',
      //               buttonText: 'إضافة',
      //           travelId: tripid ?? '',
      //             ),);
      //         // transition: Transition.rightToLeft,
      //         // duration: const Duration(milliseconds: 500));
      //   },
      //   backgroundColor: kMainColor,
      //   child: const Icon(
      //     Icons.edit_outlined,
      //     size: 30,
      //     color: Colors.black,
      //   ),
      // ),
    );
  }

  Widget allcards(BuildContext context , String tripType) {
   String? userId = FirebaseAuth.instance.currentUser?.uid;
    print('current user id: ${FirebaseAuth.instance.currentUser?.uid}');
    print('the trip id is: ${widget.tripid}');
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(kMessagesCollections)
          .where('userId', isEqualTo: userId)
          .where('travelId', isEqualTo: widget.tripid)
          .where('type', isEqualTo: tripType)
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('snapshot error: ${snapshot.error}');
          return Text("Error: ${snapshot.error}");

        }
        if (!snapshot.hasData) {
          return ModalProgressHUD(inAsyncCall: true,child: const Center(child: Text('جاري التحميل....'),),); // LodingView
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // print(tripid);
                  Get.to(
                    () => FormPage(
                      gpsControllerText: snapshot.data!.docs[index]['gps'],
                      passengerControllerText:
                          snapshot.data!.docs[index]['passenger'],
                      hotelControllerText: snapshot.data!.docs[index]['hotel'],
                      groupControllerText: snapshot.data!.docs[index]['group'],
                 notesControllerText: snapshot.data!.docs[index]['notes'],
                      busNumberText: snapshot.data!.docs[index]['busNumber'],
                      groupNameText: snapshot.data!.docs[index]['groupName'],

                      tripid: snapshot.data!.docs[index].id,
                      buttonText: 'تعديل',
                      title: "التعديل على الرحلة الحالية",
                      travelId: widget.tripid ?? '',
                    ),
                  );
                },
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      alignment: Alignment.center,
                      title: const Text(
                        'حذف الرحلة:',
                        textDirection: ui.TextDirection.rtl,
                      ),
                      content: const Text(
                        'هل تريد بالفعل حذف الرحلة؟',
                        textDirection: ui.TextDirection.rtl,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('لا'),
                        ),
                        TextButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection(kMessagesCollections)
                                .doc(snapshot.data!.docs[index].id)
                                .delete();
                            showSnackBar(
                              context,
                              'تم حذف الرحلة',
                            );
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'نعم',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: cardDetails(snapshot.data!.docs[index], tripType),
              );
            },
          );
        }
      },
    );
  }

  Widget cardDetails(DocumentSnapshot docment, String type) {
    Timestamp t = docment['time'];
    DateTime d = t.toDate();
    String formattedDateTime =
        DateFormat('yyyy/MM/dd  -  hh:mm a').format(d);
    if (type == 'bus') {
      return _buildBusCard(docment, formattedDateTime);
    } else {
      return _buildDeanaCard(docment, formattedDateTime);
    }
  }

  Widget _buildBusCard(DocumentSnapshot doc, String time) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Container(
              color: kSecondaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.directions_bus, color: Colors.white, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        'باص رقم: ${doc['busNumber']}',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    doc['groupName'] ?? '',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: _infoTile(Icons.hotel, 'الفندق', doc['gps'].toString()),
                  ),
                  Container(width: 1, height: 50, color: Colors.grey[200]),
                  Expanded(
                    child: _infoTile(Icons.people, 'الحجاج', doc['passenger'].toString()),
                  ),
                  Container(width: 1, height: 50, color: Colors.grey[200]),
                  Expanded(
                    child: _infoTile(Icons.person, 'السائق', doc['group'] ?? ''),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.grey[50],
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                children: [
                  const Icon(Icons.access_time, size: 12, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    time,
                    style: const TextStyle(fontSize: 11, color: Colors.grey, fontFamily: 'Cairo'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeanaCard(DocumentSnapshot doc, String time) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Container(
              color: const Color(0xff4a7c59),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.local_taxi, color: Colors.white, size: 18),
                      const SizedBox(width: 6),
                      const Text(
                        'دينة',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    doc['groupName'] ?? '',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: _infoTile(Icons.person_outline, 'السائق', doc['group'] ?? ''),
                  ),
                  Container(width: 1, height: 50, color: Colors.grey[200]),
                  Expanded(
                    child: _infoTile(Icons.phone_android, 'الجوال', doc['hotel'].toString()),
                  ),
                ],
              ),
            ),
            if ((doc['notes'] ?? '').toString().isNotEmpty)
              Container(
                width: double.infinity,
                color: Colors.amber[50],
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.notes, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        doc['notes'].toString(),
                        style: const TextStyle(fontSize: 11, fontFamily: 'Cairo'),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            Container(
              color: Colors.grey[50],
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                children: [
                  const Icon(Icons.access_time, size: 12, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    time,
                    style: const TextStyle(fontSize: 11, color: Colors.grey, fontFamily: 'Cairo'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 18, color: kSecondaryColor),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.grey[500], fontFamily: 'Cairo'),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      icon: Icons.add, // Icon for the FAB
      activeIcon: Icons.close, // Icon when the FAB is opened
      spacing: 3,
      spaceBetweenChildren: 4,
      // openCloseDial: openCloseDial,
      buttonSize: Size(60, 60), // It's the FloatingActionButton size
      visible: true,
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: kMainColor,
      overlayOpacity: 0.5,
      onOpen: () => print('Opening dial'),
      onClose: () => print('Dial closed'),
      tooltip: 'Options',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: kMainColor,
      foregroundColor: Colors.black,
      elevation: 8.0,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
          child: Icon(Icons.shopping_bag_rounded),
          backgroundColor: Colors.green,
          label: 'إضافة دينة جديدة',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () {
            Get.to(
              () => DeanaFormPage(
                tripid: '',
                title: 'إضافة دينه جديد',
                buttonText: 'إضافة',
                travelId: widget.tripid ?? '',
              ),
            );
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.bus_alert),
          backgroundColor: Colors.red,
          label: 'اضافة باص جديد',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () {
            Get.to(
                        () => FormPage(
                              tripid: '',
                              title: 'إضافة باص جديد',
                              buttonText: 'إضافة',
                          travelId: widget.tripid ?? '',
                            ),);
                        // transition: Transition.rightToLeft,
                        // duration: const Duration(milliseconds: 500));
                  },



        ),

      ],
    );
  }
  Stream<QuerySnapshot> getStreamBasedOnSelection(int value) {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    String typeFilter = value == 0 ? 'deana' : 'bus';
    return FirebaseFirestore.instance
        .collection(kMessagesCollections)
        .where('userId', isEqualTo: userId)
        .where('type', isEqualTo: typeFilter)
        .orderBy('time', descending: true)
        .snapshots();
  }
}


                // isTapped = true;
                // setState(() {
                //   isTapped == true ? FormPage.text='fvr' : FormPage.title='fvrdsdfv' ;

                // });
                //  isTapped = true;
                //   if( isTapped = true){
                //     Get.to(()=>FormPage(title: Text('تعديل الباص الحالي'),));
                //   }else {isTapped= false;} ;


// body: ListView.builder(
              
//               itemBuilder:(context, index){ 
//                 return Column(
//                 children: [
                  // VerticalSpace(2),
                  // MainFrameWidget(
                  //   onLongPress: () {
                      
                  //   },
//                     onTap: () {
//                       Get.to(
//                         () => FormPage(
//                           title: 'تعديل على الرحلة الحالية',
//                           buttonText: 'تعديل',
//                         ),
//                       );
//                     },
//                     hotelName: 'الازهر',
//                     group: 'السلام',
//                     passengerNo: 38,
//                     gpsNo: 30,
//                   ),
                  
//                 ],
              
//               );
//               }
//             ),

// FirebaseFirestore.instance.collection(kMessagesCollections).doc(snapshot.data!.docs[index].id)
//                   .set({
// 'gps' : contorller.text
// });