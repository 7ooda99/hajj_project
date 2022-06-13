import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syrian_hajj_project/core/constants.dart';
import 'package:syrian_hajj_project/core/widgets/space_widget.dart';
import 'package:syrian_hajj_project/helper/show_snack_bar.dart';
import 'package:syrian_hajj_project/pages/airport_page.dart';
import 'package:syrian_hajj_project/pages/widgets/custom_button.dart';
import 'package:syrian_hajj_project/pages/widgets/custom_text_field.dart';

import '../core/size_config.dart';

// ignore: must_be_immutable
class FormPage extends StatelessWidget {
  final String tripid;

//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//   NotificationSettings settings = await messaging.requestPermission(
//   alert: true,
//   announcement: false,
//   badge: true,
//   carPlay: false,
//   criticalAlert: false,
//   provisional: false,
//   sound: true,
// );

  FormPage({Key? key, required this.tripid, this.title, this.buttonText})
      : super(key: key);

  @override
  
  
  void updateForm() {
    final group = groupController.text;
    final hotel = hotelController.text;
    final passenger = passengerController.text;
    final gps = gpsController.text;
    final notes = notesController.text;

    var collection =
        FirebaseFirestore.instance.collection(kMessagesCollections);
    collection.doc(tripid).update({
      "group": group,
      "hotel": hotel,
      "passenger": passenger,
      "gps": gps,
      "notes": notes,
      // "time": Timestamp.now(),
    });
    //  collection.doc('hotel').update({'hotel':hotel});
    //  collection.doc('passenger').update({'passenger':passenger});
    //  collection.doc('gps').update({'gps':gps});
    //  collection.doc('notes').update({'notes':notes});
    //  collection.doc('time').update({'time':Timestamp.now()});
  }

  void saveForm() {
    final group = groupController.text;
    final hotel = hotelController.text;
    final passenger = passengerController.text;
    final gps = gpsController.text;
    final notes = notesController.text;
    FirebaseFirestore.instance.collection(kMessagesCollections).doc().set({
      "group": group,
      "hotel": hotel,
      "passenger": passenger,
      "gps": gps,
      "notes": notes,
      "time": Timestamp.now(),
    });
  }

  CollectionReference formInfo =
      FirebaseFirestore.instance.collection(kMessagesCollections);

      
  TextEditingController groupController = TextEditingController();
  TextEditingController hotelController = TextEditingController();
  TextEditingController passengerController = TextEditingController();
  TextEditingController gpsController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  static String id = 'FormPage';
  final _formKey = GlobalKey<FormState>();
  final String? title;
  final String? buttonText;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        centerTitle: true,
        backgroundColor: kMainColor,
        title: Text(
          title!,
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'Cairo',
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            const VerticalSpace(2),
            CustomTextField(
              validator: (value) {
            if (value == null || value.isEmpty) {
              return 'الرجاء ادخال بيانات';
            }
            return null;
          },
              controller: groupController,
              onSaved: (data) {
                formInfo.add({'group': data});
              },
              lableText: 'الحملة',
              maxLines: 1,
            ),
            const VerticalSpace(2),
            CustomTextField(
              validator: (value) {
            if (value == null || value.isEmpty) {
              return 'الرجاء ادخال بيانات';
            }
            return null;
          },
              controller: hotelController,
              onSaved: (data) {
                formInfo.add({'hotel': data});
              },
              lableText: 'الفندق',
              maxLines: 1,
            ),
            const VerticalSpace(2),
            Row(
              children: [
                SizedBox(
                  width: SizeConfig.defaultSize! * 21,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: CustomSmallTextField(
                      controller: gpsController,
                      onSaved: (data) {
                        formInfo.add({'gps': data});
                      },
                      lableText: 'رقم GPS',
                      maxLines: 1,
                      inputType: TextInputType.number,
                    ),
                  ),
                ),
                const Spacer(
                  flex: 1,
                ),
                SizedBox(
                  width: SizeConfig.defaultSize! * 20,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: CustomSmallTextField(
                      controller: passengerController,
                      onSaved: (data) {
                        formInfo.add({'passenger': data});
                      },
                      lableText: 'عدد الركاب',
                      inputType: TextInputType.number,
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
            ),
            const VerticalSpace(4),
            Divider(
              indent: SizeConfig.defaultSize! * 2,
              endIndent: SizeConfig.defaultSize! * 2,
              thickness: 1,
              color: Colors.black,
            ),
            const VerticalSpace(2),
            // Row(
            //   children: [
            //     Container(
            //       width: SizeConfig.defaultSize! * 21,
            //       child: Padding(
            //         padding: const EdgeInsets.only(left: 5),
            //         child: CustomButton(
            //           text: 'التاريخ',
            //           color: kSecondaryColor,
            //           onTap: () {
            //             DatePicker.showDatePicker(context,
            //                 theme: DatePickerTheme(
            //                   itemHeight: 50,
            //                   backgroundColor: Colors.white,
            //                 ),
            //                 showTitleActions: true,
            //                 minTime: DateTime(2022, 6, 1),
            //                 maxTime: DateTime(2022, 7, 31), onChanged: (date) {
            //               print('change $date');
            //             }, onConfirm: (date) {
            //               print('confirm $date');
            //             }, currentTime: DateTime.now(), locale: LocaleType.ar);
            //           },
            //         ),
            //       ),
            //     ),
            // Spacer(flex: 1),
            // Container(
            //   width: SizeConfig.defaultSize! * 20,
            //   child: Padding(
            //     padding: const EdgeInsets.only(right: 5),
            //     child: CustomButton(
            //       text: 'الوقت',
            //       color: kSecondaryColor,
            //       onTap: () {
            //         Future<TimeOfDay?> selectedTimeRTL = showTimePicker(
            //           context: context,
            //           initialTime: TimeOfDay.now(),
            //           builder: (BuildContext context, Widget? child) {
            //             return Directionality(
            //               textDirection: TextDirection.rtl,
            //               child: child!,
            //             );
            //           },
            //         );
            //       },
            //     ),
            //   ),
            // ),
            // ],
            // ),
            const VerticalSpace(2),
            CustomTextField(
              controller: notesController,
              onSaved: (data) {
                formInfo.add({'notes': data});
              },
              lableText: 'ملاحظات',
              maxLines: 5,
            ),
            const VerticalSpace(16),
            CustomButton(
              text: buttonText,
              color: kMainColor,
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  if (buttonText == 'إضافة') {
                    Get.to(() => AirportPage());
                    showSnackBar(context, 'تم اضافة الرحلة');
                    
                    saveForm();
                  } else {
                    Get.to(() => AirportPage());
                    showSnackBar(context, 'تم  تعديل الرحلة');
                    updateForm();
                  }
                } else {
                  return;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

