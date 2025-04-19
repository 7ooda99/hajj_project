

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
import 'package:syrian_hajj_project/pages/widgets/airport_frame_widget.dart';
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
        leading:  IconButton(
          onPressed: () {
            Get.off(() => AirportMainPage());
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        backgroundColor: kMainColor,
        centerTitle: true,
        title:  Text(
          '${widget.tripName} رحلة ',
          style: TextStyle(color: Colors.black, fontFamily: 'Cairo'),
        ),

      ),
      body:

           Column(
            children: [
               // if ( tripType == 'bus')

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomSlidingSegmentedControl<int>(
                  // innerPadding: 3,
                  innerPadding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  fixedWidth: SizeConfig.defaultSize! * 18,
                  thumbDecoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                   initialValue: 1,

                  children: const {
                    0: Text('دينات', style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Cairo',
                      color: Colors.black,
                    ),),
                    1: Text('باصات', style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Cairo',
                      color: Colors.black,
                    ),),

                  },
                  // onValueChanged: (value) {
                  //   setState(() {
                  //     segmentedControlValue = value;
                  //   });
                  //   // Optional: Add logic to filter/sort your list based on the selected value
                  // },
                  // initialValue: segmentedControlValue,
                  onValueChanged: (int value) {
                    setState(() {
                      selectedValue = value;
                      tripType = value == 0 ? 'deana' : 'bus';
                      // itemStream = getStreamBasedOnSelection(selectedValue);
                    });
                    // fetchDataBasedOnSelection(value);
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
                child: cardDetails(snapshot.data!.docs[index]),
              );
            },
          );
        }
      },
    );
  }

  Widget cardDetails(DocumentSnapshot docment) {
    Timestamp t = docment['time'];
    DateTime d = t.toDate();
    // DateFormat.yMMMd().add_jm().format(d);
    String formattedDateTime =
        DateFormat('yyyy/MM/dd       -       hh:mm  a').format(d);
    return AirportFrameWidget(
      hotelName: docment['gps'].toString(),
      group: docment['groupName'],
      passengerNo: docment['passenger'].toString(),
      gpsNo: docment['busNumber'].toString(),
      time: formattedDateTime,
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