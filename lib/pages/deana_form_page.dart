import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
class DeanaFormPage extends StatefulWidget {
  final String tripid;
  final String? travelId;
  final String? groupControllerText;
  final String? hotelControllerText;
  final String? passengerControllerText;
  final String? gpsControllerText;
  final String? groupNameText;
  final String? busNumberText;
  final String? notesControllerText;

  DeanaFormPage({
    Key? key,
    required this.tripid,
    this.title,
    this.buttonText,
    this.travelId,
    this.groupControllerText,
    this.hotelControllerText,
    this.passengerControllerText,
    this.gpsControllerText,
    this.notesControllerText,
    this.groupNameText,
    this.busNumberText,

  })  : groupController = TextEditingController(text: groupControllerText),
        hotelController = TextEditingController(text: hotelControllerText),
        passengerController = TextEditingController(text: passengerControllerText),
        gpsController = TextEditingController(text: gpsControllerText),
        busNumber = TextEditingController(text: busNumberText),
        groupName = TextEditingController(text: groupNameText),
        notesController = TextEditingController(text: notesControllerText),
        super(key: key);

  @override

  TextEditingController groupController = TextEditingController(

  ) ;
  TextEditingController hotelController = TextEditingController();
  TextEditingController passengerController = TextEditingController();
  TextEditingController gpsController = TextEditingController();
  TextEditingController busNumber = TextEditingController();
  TextEditingController groupName = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController groupNumber = TextEditingController();
  TextEditingController hotelName = TextEditingController();
  TextEditingController groupName2 = TextEditingController();


  static String id = 'FormPage';
  final String? title;
  final String? buttonText;

  @override
  State<DeanaFormPage> createState() => _DeanaFormPageState();
}

class _DeanaFormPageState extends State<DeanaFormPage> {
  List<TextEditingController> _controllers = [];

  Future<void> updateForm() async {
    String userId = await FirebaseAuth.instance.currentUser?.uid ?? '';

    final group = widget.groupController.text;
    final hotel = widget.hotelController.text;
    final passenger = widget.passengerController.text;
    final groupName = widget.groupName.text;
    final busNumber = widget.busNumber.text;
    final gps = widget.gpsController.text;
    final notes = widget.notesController.text;
    var collection =
    FirebaseFirestore.instance.collection(kMessagesCollections);
    collection.doc(widget.tripid).update({
      "userId": userId,
      "group": group,
      "hotel": hotel,
      "passenger": passenger,
      "gps": gps,
      "groupName": groupName,
      "busNumber": busNumber,
      "notes": notes,
      // "time": Timestamp.now(),
      "travelId" : widget.travelId,
      "type": "deana",
      // "time": Timestamp.now(),
    });
    //  collection.doc('hotel').update({'hotel':hotel});
    //  collection.doc('passenger').update({'passenger':passenger});
    //  collection.doc('gps').update({'gps':gps});
    //  collection.doc('notes').update({'notes':notes});
    //  collection.doc('time').update({'time':Timestamp.now()});
  }

  Future<void> saveForm() async {
    String userId = await FirebaseAuth.instance.currentUser?.uid ?? '';

    final group = widget.groupController.text;
    final hotel = widget.hotelController.text;
    final passenger = widget.passengerController.text;
    final groupName = widget.groupName.text;
    final busNumber = widget.busNumber.text;
    final gps = widget.gpsController.text;
    final notes = widget.notesController.text;
    FirebaseFirestore.instance.collection(kMessagesCollections).doc().set({
      "userId": userId,
      "group": group,
      "hotel": hotel,
      "passenger": passenger,
      "gps": gps,
      "groupName": groupName,
      "busNumber": busNumber,
      "notes": notes,
      "time": Timestamp.now(),
      "travelId" : widget.travelId,
      "type": "deana",
    });
  }

  CollectionReference formInfo =
  FirebaseFirestore.instance.collection(kMessagesCollections);

  final _formKey = GlobalKey<FormState>();

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
        automaticallyImplyLeading: false,
        leading:  IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: Text(
          widget.title!,
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
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء ادخال بيانات';
                      }
                      return null;
                    },
                    controller: widget.hotelController,
                    onSaved: (data) {
                      formInfo.add({'hotel': data});
                    },
                    lableText: ' جوال السائق',
                    inputType: TextInputType.number,
                    maxLines: 1,
                  ),
                ),
                Expanded(
                  child: CustomTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء ادخال بيانات';
                      }
                      return null;
                    },
                    controller: widget.groupController,
                    onSaved: (data) {
                      formInfo.add({'group': data});
                    },
                    lableText: 'اسم السائق',
                    maxLines: 1,
                  ),
                ),
                // const HorizintalSpace(2),


              ],
            ),

            const VerticalSpace(2),
            // Row(
            //   children: [
            //     SizedBox(
            //       width: SizeConfig.defaultSize! * 21,
            //       child: Padding(
            //         padding: const EdgeInsets.only(left: 5),
            //         child: CustomSmallTextField(
            //           controller: widget.groupName,
            //           onSaved: (data) {
            //             formInfo.add({'groupName': data});
            //           },
            //           lableText: 'اسم المجموعة',
            //           maxLines: 1,
            //
            //         ),
            //       ),
            //     ),
            //     const Spacer(
            //       flex: 1,
            //     ),
            //     SizedBox(
            //       width: SizeConfig.defaultSize! * 20,
            //       child: Padding(
            //         padding: const EdgeInsets.only(right: 5),
            //         child: CustomSmallTextField(
            //           controller: widget.busNumber,
            //           onSaved: (data) {
            //             formInfo.add({'busNumber': data});
            //           },
            //           lableText: 'رقم الباص',
            //           // inputType: TextInputType.number,
            //           maxLines: 1,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // const VerticalSpace(2),
            // Row(
            //   children: [
            //     SizedBox(
            //       width: SizeConfig.defaultSize! * 21,
            //       child: Padding(
            //         padding: const EdgeInsets.only(left: 5),
            //         child: CustomSmallTextField(
            //           controller: widget.gpsController,
            //           onSaved: (data) {
            //             formInfo.add({'gps': data});
            //           },
            //           lableText: 'الفندق',
            //           maxLines: 1,
            //         ),
            //       ),
            //     ),
            //     const Spacer(
            //       flex: 1,
            //     ),
            //     SizedBox(
            //       width: SizeConfig.defaultSize! * 20,
            //       child: Padding(
            //         padding: const EdgeInsets.only(right: 5),
            //         child: CustomSmallTextField(
            //           controller: widget.passengerController,
            //           onSaved: (data) {
            //             formInfo.add({'passenger': data});
            //           },
            //           lableText: 'عدد الحجاج',
            //           inputType: TextInputType.number,
            //           maxLines: 1,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // const VerticalSpace(2),
            GestureDetector(
              onTap: () {
                showDialog(
                  useSafeArea: true,
                  context: context,
                  builder: (_) => SizedBox(
                    height: 200,
                    child: AlertDialog(

                      alignment: Alignment.center,
                      title: const Text(
                        'بيانات المجموعه :',
                        textDirection: ui.TextDirection.rtl,
                      ),
                      content: Column(
                        children: [
                          CustomSmallTextField(
                            controller: widget.groupName2,
                            onSaved: (data) {
                              // formInfo.add({'gps': data});
                            },
                            lableText: 'اسم المجموعة',
                            maxLines: 1,
                            inputType: TextInputType.number,
                          ),
                          VerticalSpace(2),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: CustomSmallTextField(
                                  controller: widget.hotelName,
                                  onSaved: (data) {
                                    // formInfo.add({'gps': data});
                                  },

                                  lableText: 'الفندق',
                                  maxLines: 1,
                                  inputType: TextInputType.number,
                                ),
                              ),
                              // const Spacer(
                              //   flex: 1,
                              // ),
                              Expanded(
                                flex: 1,
                                child: CustomSmallTextField(
                                  controller: widget.groupNumber,
                                  onSaved: (data) {
                                    // formInfo.add({'passenger': data});

                                  },
                                  lableText: 'العدد',
                                  inputType: TextInputType.number,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // content: const Text(
                      //   'هل تريد بالفعل حذف الرحلة؟',
                      //   textDirection: ui.TextDirection.rtl,
                      // ),
                      actions: [
                        TextButton(
                          onPressed: () {

                            Navigator.pop(context);
                          },
                          child: const Text(
                            'تراجع',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            widget.notesController.text += 'مجموعة اضافية :- \n اسم المجموعة : ${widget.groupName2.text} \n العدد : ${widget.groupNumber.text} \nالفندق : ${widget.hotelName.text}\n ';
                            widget.hotelName.text = '';
                            widget.groupNumber.text = '';
                            widget.groupName2.text = '';
                            Navigator.pop(context);
                          },
                          child: const Text('إضافة'),
                        ),

                      ],
                    ),
                  ),
                );
              },
              child: Container(
                // height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    // shape: BoxShape.circle,
                    border: Border.all(
                      color: kMainColor,
                      width: 2,
                    ),
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('أضف مجموعة حقائب'),
                      Icon(
                        Icons.add,


                      ),
                    ],
                  )),
            ),
            const VerticalSpace(4),
            // Divider(
            //   indent: SizeConfig.defaultSize! * 2,
            //   endIndent: SizeConfig.defaultSize! * 2,
            //   thickness: 1,
            //   color: Colors.black,
            // ),
            // const VerticalSpace(4),


            // Row(
            //   children: [
            //     SizedBox(
            //       width: SizeConfig.defaultSize! * 21,
            //       child: Padding(
            //         padding: const EdgeInsets.only(left: 5),
            //         child: CustomSmallTextField(
            //           controller: widget.gpsController,
            //           onSaved: (data) {
            //             formInfo.add({'gps': data});
            //           },
            //           lableText: 'رقم GPS',
            //           maxLines: 1,
            //           inputType: TextInputType.number,
            //         ),
            //       ),
            //     ),
            //     const Spacer(
            //       flex: 1,
            //     ),
            //     SizedBox(
            //       width: SizeConfig.defaultSize! * 20,
            //       child: Padding(
            //         padding: const EdgeInsets.only(right: 5),
            //         child: CustomSmallTextField(
            //           controller: widget.passengerController,
            //           onSaved: (data) {
            //             formInfo.add({'passenger': data});
            //           },
            //           lableText: 'عدد الحجاج',
            //           inputType: TextInputType.number,
            //           maxLines: 1,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // const VerticalSpace(4),
            CustomTextField(
              controller: widget.notesController,
              onSaved: (data) {
                formInfo.add({'notes': data});
              },
              lableText: 'ملاحظات',
              maxLines: 7,
            ),

            const VerticalSpace(2),
            CustomButton(
              text: widget.buttonText,
              color: kMainColor,
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  if (widget.buttonText == 'إضافة') {
                    Get.back();
                    showSnackBar(context, 'تم اضافة الرحلة');

                    saveForm();
                  } else {
                    Get.back();
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

