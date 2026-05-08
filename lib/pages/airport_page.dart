

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
import 'package:syrian_hajj_project/pages/widgets/deana_airport_frame_widget.dart';
import '../core/size_config.dart';

class AirportPage extends StatefulWidget {
  final String? tripName;
  final String? tripid;
  final String? role;


  AirportPage({Key? key,  this.tripName, this.tripid,  this.role, }) : super(key: key);

  static String id = 'AirportPage';


  @override
  State<AirportPage> createState() => _AirportPageState();

}


class _AirportPageState extends State<AirportPage> {

  CollectionReference formInfo =
      FirebaseFirestore.instance.collection(kMessagesCollections);
  int selectedValue = 0;
  late Stream<QuerySnapshot> itemStream;
   String tripType = 'باص';
  @override
  void initState() {
    super.initState();
    // itemStream = getStreamBasedOnSelection(selectedValue ); // Initialize with default stream
  }
  // final String ttripid=
  final bool isTapped = false;

  @override
  Widget build(BuildContext context) {

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
                      tripType = value == 0 ? 'دينه' : 'باص';
                      // itemStream = getStreamBasedOnSelection(selectedValue);
                    });
                    // fetchDataBasedOnSelection(value);
                  },
                ),
              ),
              Expanded(child: allcards(context, tripType)),
            ],
          ),


      floatingActionButton: widget.role != 'admin' ? buildSpeedDial() : SizedBox.shrink(),
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
      stream: widget.role != 'admin' ?

      FirebaseFirestore.instance
          .collection(kMessagesCollections)
          .where('userId', isEqualTo: userId)
          .where('travelId', isEqualTo: widget.tripid)
          .where('type', isEqualTo: tripType)
          .orderBy('time', descending: true)
          .snapshots() :
      FirebaseFirestore.instance
          .collection(kMessagesCollections)
          // .where('userId', isEqualTo: userId)
          .where('travelId', isEqualTo: widget.tripid)
          .where('type', isEqualTo: tripType)
          .orderBy('time', descending: true)
          .snapshots()
      ,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('snapshot error: ${snapshot.error}');
          return Text("Error: ${snapshot.error}");

        }
        if (snapshot.data?.docs.isEmpty ?? true) {
          // Display message when no data found
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 50,
                  color: Colors.grey,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Text(
                    'لا توجد بيانات متوفرة ',
                    textDirection: ui.TextDirection.rtl,

                    style: TextStyle(

                      fontFamily: 'Cairo',
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),


                ),
                Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Text(
                    'اضغط على الزر + لإضافة باص او دينه جديدة',
                    textDirection: ui.TextDirection.rtl,

                    style: TextStyle(

                      fontFamily: 'Cairo',
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),


                ),
              ],
            ),
          );
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
                    () => snapshot.data!.docs[index]['type'] == 'باص'? FormPage(
                      userRole: widget.role,
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
                      transfareCompanyText: snapshot.data!.docs[index]['transfareCompany'],
                    ) : DeanaFormPage(
                      userRole: widget.role,
                      gpsControllerText: snapshot.data!.docs[index]['gps'],
                      passengerControllerText:
                          snapshot.data!.docs[index]['passenger'],
                      totalBagsText: snapshot.data!.docs[index]['totalBags'],
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
                        'خيارات الرحلة:',
                        textDirection: ui.TextDirection.rtl,
                      ),
                      content: const Text(
                        'ماذا تريد أن تفعل بالرحلة؟',
                        textDirection: ui.TextDirection.rtl,
                      ),
                      actionsAlignment: MainAxisAlignment.spaceEvenly,
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('إلغاء', style: TextStyle(color: Colors.black)),
                        ),
                        TextButton(
                          onPressed: () async {
                            final currentData = snapshot.data!.docs[index].data() as Map<String, dynamic>;

                            // Set specific fields to empty values instead of removing
                            currentData['busNumber'] = '';
                            currentData['notes'] = '';
                            currentData['passenger'] = '';
                            currentData['group'] = '';
                            currentData['hotel'] = '';

                            // Update the timestamp for the new copy
                            currentData['time'] = Timestamp.now();

                            // Add the modified data as a new document
                            await FirebaseFirestore.instance
                                .collection(kMessagesCollections)
                                .add(currentData);

                            showSnackBar(context, 'تم نسخ الرحلة بنجاح مع إفراغ البيانات المحددة');
                            // Navigator.pop(context);
                          },
                          child: const Text('نسخ', style: TextStyle(color: Colors.blue)),
                        ),
                        TextButton(
                          onPressed: () async {
                            final docId = snapshot.data!.docs[index].id;

                            await FirebaseFirestore.instance
                                .collection(kMessagesCollections)
                                .doc(docId)
                                .update({'sent': true});

                            showSnackBar(context, 'تم الإرسال بنجاح');
                            Navigator.pop(context);
                          },
                          child: const Text('تم الإرسال', style: TextStyle(color: Colors.green)),
                        ),
                        Directionality(
                          textDirection: ui.TextDirection.rtl,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context); // إغلاق الحوار الأول

                              // عرض حوار التأكيد الثاني
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  alignment: Alignment.center,
                                  title: Directionality(
                                    textDirection: ui.TextDirection.rtl,
                                    child: Text(
                                      'تأكيد الحذف',
                                      // textDirection: TextDirection.rtl,
                                    ),
                                  ),
                                  content: Text(
                                    'هل أنت متأكد من أنك تريد حذف هذه الرحلة نهائيًا؟',
                                    // textDirection: TextDirection.rtl,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('إلغاء', style: TextStyle(color: Colors.black)),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        final docId = snapshot.data!.docs[index].id;
                                        await FirebaseFirestore.instance
                                            .collection(kMessagesCollections)
                                            .doc(docId)
                                            .delete();

                                        Navigator.pop(context); // إغلاق الحوار الثاني
                                        showSnackBar(context, 'تم حذف الرحلة');
                                      },
                                      child: const Text('تأكيد الحذف', style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: const Text('حذف', style: TextStyle(color: Colors.red)),
                          ),
                        ),

                      ],
                    ),
                  );
                },
                child: snapshot.data!.docs[index]['type'] == 'باص'? busCardDetails(snapshot.data!.docs[index], index) : deanaCardDetails(snapshot.data!.docs[index], index) ,
              );
            },
          );
        }
      },
    );
  }

  Widget busCardDetails(DocumentSnapshot docment, int index) {
    Timestamp t = docment['time'];
    DateTime d = t.toDate();
    // DateFormat.yMMMd().add_jm().format(d);
    String formattedDateTime =
        DateFormat('yyyy/MM/dd - hh:mm  a').format(d);
    return AirportFrameWidget(
      userRole: widget.role,
      index: index,
      tripName: widget.tripName ?? '',
travelId: widget.tripid ?? '',
      hotelName: docment['gps'].toString(),
      group: docment['groupName'],
      passengerNo: docment['passenger'].toString(),
      gpsNo: docment['busNumber'].toString(),
      time: formattedDateTime,
      isSent: docment['sent'] ?? false,
    );
  }
  Widget deanaCardDetails(DocumentSnapshot docment, int index) {
    Timestamp t = docment['time'];
    DateTime d = t.toDate();
    // DateFormat.yMMMd().add_jm().format(d);
    String formattedDateTime =
    DateFormat('yyyy/MM/dd - hh:mm  a').format(d);
    return DeanaAirportFrameWidget(
      userRole: widget.role,
      travelId: widget.tripid ?? '',
      tripName: widget.tripName ?? '',
      index: index,
      hotelName: docment['gps'].toString(),
      group: docment['groupName'],
      passengerNo: docment['groupName'].toString(),
      gpsNo: docment['totalBags'].toString(),
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