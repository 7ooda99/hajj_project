

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:syrian_hajj_project/core/constants.dart';
import 'dart:ui' as ui;
import 'package:syrian_hajj_project/helper/show_snack_bar.dart';

import 'package:syrian_hajj_project/pages/form_page.dart';
import 'package:syrian_hajj_project/pages/widgets/airport_frame_widget.dart';
import 'package:intl/intl.dart';
import '../core/size_config.dart';

class AirportPage extends StatelessWidget {
  CollectionReference formInfo =
      FirebaseFirestore.instance.collection(kMessagesCollections);

  static String id = 'AirportPage';

  final bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(
    color: Colors.black, //change your color here
  ),
        backgroundColor: kMainColor,
        centerTitle: true,
        title: const Text(
          'تفويج المطار',
          style: TextStyle(color: Colors.black, fontFamily: 'Cairo'),
        ),
        
      ),
      body: allcards(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(
              () => FormPage(
                    tripid: '',
                    title: 'إضافة رحلة جديدة',
                    buttonText: 'إضافة',
                  ),
              transition: Transition.rightToLeft,
              duration: const Duration(milliseconds: 500));
        },
        backgroundColor: kMainColor,
        child: const Icon(
          Icons.edit_outlined,
          size: 30,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget allcards(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(kMessagesCollections).orderBy('time',descending: true)
          .snapshots(),
      builder: (context, snapshot) {
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
                      tripid: snapshot.data!.docs[index].id,
                      buttonText: 'تعديل',
                      title: "التعديل على الرحلة الحالية",
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
      hotelName: docment['hotel'],
      group: docment['group'],
      passengerNo: docment['passenger'].toString(),
      gpsNo: docment['gps'].toString(),
      time: formattedDateTime,
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