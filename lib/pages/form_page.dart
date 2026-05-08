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
class FormPage extends StatefulWidget {
  final String tripid;
  final String? travelId;
   final String? groupControllerText;
  final String? hotelControllerText;
  final String? passengerControllerText;
  final String? gpsControllerText;
  final String? groupNameText;
  final String? busNumberText;
  final String? notesControllerText;
  final String? transfareCompanyText;
  final String? userRole;
  FormPage({
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
    this.transfareCompanyText, this.userRole,

  })  : groupController = TextEditingController(text: groupControllerText),
        hotelController = TextEditingController(text: hotelControllerText),
        passengerController = TextEditingController(text: passengerControllerText),
        gpsController = TextEditingController(text: gpsControllerText),
        busNumber = TextEditingController(text: busNumberText),
        groupName = TextEditingController(text: groupNameText),
        notesController = TextEditingController(text: notesControllerText),
        transfareCompany = TextEditingController(text: transfareCompanyText),
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
  TextEditingController transfareCompany = TextEditingController();


  static String id = 'FormPage';
  final String? title;
  final String? buttonText;

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  List<TextEditingController> _controllers = [];
  @override
  void initState() {
    super.initState();
    widget.transfareCompany.text = widget.transfareCompany.text.isNotEmpty ? widget.transfareCompany.text : 'حافل'; // Set your initial value here
  }
  String? selectedHotel;

  void updateForm() {
    final group = widget.groupController.text;
    final hotel = widget.hotelController.text;
    final passenger = widget.passengerController.text;
    final groupName = widget.groupName.text;
    final busNumber = widget.busNumber.text;
    final gps = widget.gpsController.text;
    final notes = widget.notesController.text;
    final transfareCompany = widget.transfareCompany.text;

    var collection =
        FirebaseFirestore.instance.collection(kMessagesCollections);
    collection.doc(widget.tripid).update({
      "group": group,
      "hotel": hotel,
      "passenger": passenger,
      "gps": gps,
      "notes": notes,
      "groupName": groupName,
      "busNumber": busNumber,
      "travelId" : widget.travelId,
      "transfareCompany" : transfareCompany,
      "type": "باص",
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
    final transfareCompany = widget.transfareCompany.text;
    FirebaseFirestore.instance.collection(kMessagesCollections).doc().set({
      "userId": userId,
      "group": group,
      "hotel": hotel,
      "passenger": passenger,
      "gps": gps,
      "groupName": groupName,
      "busNumber": busNumber,
      "notes": notes,
      "sent": false,
      "time": Timestamp.now(),
      "travelId" : widget.travelId,
      "type": "باص",
      "transfareCompany" : transfareCompany,
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
                    controller: widget.transfareCompany,
                    onSaved: (data) {
                      formInfo.add({'transfareCompany': data});
                    },
                    lableText: 'الشركة الناقلة',
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
                    controller: widget.busNumber,
                    onSaved: (data) {
                      formInfo.add({'busNumber': data});
                    },
                    lableText: 'رقم الباص',
                    // inputType: TextInputType.number,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            const VerticalSpace(2),
SizedBox(
  width: SizeConfig.defaultSize! * 21,
  child: Padding(
    padding: const EdgeInsets.only(right: 15, left: 15),
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: DropdownButtonFormField<String>(
        // padding: const EdgeInsets.only(right: 10),
        value: widget.groupName.text.isNotEmpty ? widget.groupName.text : null,
       style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontFamily: 'Cairo',

        ),
        borderRadius: BorderRadius.circular(10),
        alignment: Alignment.bottomRight,
        isExpanded: true,
        // menuMaxHeight: SizeConfig.defaultSize! * 50,

        decoration: const InputDecoration(
          labelText: 'اسم المجموعة/التكتل',

          labelStyle: TextStyle(

            color: Colors.black,
            fontSize: 14,
            fontFamily: 'Cairo',
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          ),
        ),
        items: [
          'المحراب',
          'القصواء',
          'عباد الرحمن',
          'البراق',
          'الرحاب الطاهره',
          'شذا مكة',
          'العمري',
          'بشروا',
          'وتعاونوا',
          'الركب الميمون',
          'الفتح المبين',
          'الماسي',
          'المشاعر',
          'الاجابة',
          'رؤيا',
          'ياسر جود - الحمد',
          'وليد قدو - العلياء',
          'فيصل حجى سلامه - الكلمة الطيبة',
          'إسطنبول',
          'الرضوان',
          'العلياء',
          'الخيرات',
          'واعتصموا',
          'عطاء',
          "نسك",
          "الأخلاء",
          'النخبة',
        ]
        .map((label) => DropdownMenuItem(
          alignment: Alignment.bottomRight,
          value: label,
          child: Text(label, textDirection: TextDirection.rtl),
        )).toList(),
        onChanged: (value) {
          setState(() {
            widget.groupName.text = value ?? '';
          });
        },
        onSaved: (value) {
          formInfo.add({'groupName': value});
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'الرجاء اختيار اسم المجموعة';
          }
          return null;
        },
      ),
    ),
  ),
),
            const VerticalSpace(2),
            Row(
              children: [
                SizedBox(
                  width: SizeConfig.defaultSize! * 21,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: DropdownButtonFormField<String>(

                        alignment: Alignment.bottomRight,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Cairo',
                          ),
                          labelText: 'الفندق',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                        ),
                        value: widget.gpsController.text.isNotEmpty ?  widget.gpsController.text: null,
                        onChanged: ( newValue) {
                          setState(() {
                            // selectedHotel = newValue!;
                            widget.gpsController.text = newValue ?? '';
                          });
                        },
                        onSaved: (value) {
                          formInfo.add({'gps': value});
                        },
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     return 'الرجاء اختيار اسم المجموعة';
                        //   }
                        //   return null;
                        // },
                        items: [
                          'الهدى',
                          'جوهرة ال صبغة B',
                          'جوهرة ال صبغة A',
                          'ميزاب البطحاء',
                          'نجم السعد',
                          'نيو ليفيل',
                          'براديس',
                          'زاد اليقين',
                          'درة النقيب',
                          'الريان',
                          'برهان الضيافة',
                          'صقر قريش',
                          'نوازي',
                          'أبراج الهداية',
                          'أبراج الطلائع',
                          'اعمار ایلیت',
                          'ورقان',
                          'اجم الششة'
                        ]
                        .map((label) => DropdownMenuItem(
                          alignment: Alignment.bottomRight,
                          value: label,
                          child: Text(label, textDirection: TextDirection.rtl),
                        )).toList(),
                      ),
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
                      controller: widget.passengerController,
                      onSaved: (data) {
                        formInfo.add({'passenger': data});
                      },
                      lableText: 'عدد الحجاج',
                      inputType: TextInputType.number,
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
            ),



            const VerticalSpace(2),
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
                          DropdownButtonFormField<String>(
                            value: widget.groupName2.text.isNotEmpty ? widget.groupName2.text : null,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: 'Cairo',
                            ),
                            borderRadius: BorderRadius.circular(10),
                            alignment: Alignment.bottomRight,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              labelText: 'اسم المجموعة',
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Cairo',
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                              ),
                            ),
                            items: [
                              'المحراب',
                              'القصواء',
                              'عباد الرحمن',
                              'البراق',
                              'الرحاب الطاهره',
                              'شذا مكة',
                              'العمري',
                              'بشروا',
                              'وتعاونوا',
                              'الركب الميمون',
                              'الفتح المبين',
                              'الماسي',
                              'المشاعر',
                              'الاجابة',
                              'رؤيا',
                              'ياسر جود - الحمد',
                              'وليد قدو - العلياء',
                              'فيصل حجى سلامه - الكلمة الطيبة',
                              'إسطنبول',
                              'الرضوان',
                              'العلياء',
                              'الخيرات',
                              'واعتصموا',
                              'عطاء',
                              "نسك",
                              "الأخلاء",
                              'النخبة',
                            ]
                            .map((label) => DropdownMenuItem(
                              alignment: Alignment.bottomRight,
                              value: label,
                              child: Text(label, textDirection: TextDirection.rtl),
                            )).toList(),
                            onChanged: (value) {
                              setState(() {
                                widget.groupName2.text = value ?? '';
                              });
                            },
                          ),
                          VerticalSpace(2),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: DropdownButtonFormField<String>(
                                  value: widget.hotelName.text.isNotEmpty ? widget.hotelName.text : null,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: 'Cairo',
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  alignment: Alignment.bottomRight,
                                  isExpanded: true,
                                  decoration: const InputDecoration(
                                    labelText: 'الفندق',
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: 'Cairo',
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  items: [
                                    'الهدى',
                                    'جوهرة ال صبغة B',
                                    'جوهرة ال صبغة A',
                                    'ميزاب البطحاء',
                                    'نجم السعد',
                                    'نيو ليفيل',
                                    'براديس',
                                    'زاد اليقين',
                                    'درة النقيب',
                                    'الريان',
                                    'برهان الضيافة',
                                    'صقر قريش',
                                    'نوازي',
                                    'أبراج الهداية',
                                    'أبراج الطلائع',
                                    'اعمار ایلیت',
                                    'ورقان',
                                    'اجم الششة'
                                  ]
                                  .map((label) => DropdownMenuItem(
                                    alignment: Alignment.bottomRight,
                                    value: label,
                                    child: Text(label, textDirection: TextDirection.rtl),
                                  )).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      widget.hotelName.text = value ?? '';
                                    });
                                  },
                                ),
                              ),
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
                          child: const Text('إضافة' ,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
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
                      Text('أضف مجموعة اخرى'),
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
            widget.userRole != 'admin' ?
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
            ) : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }


}

// الرحلة: ٢
// نوع الرحلة: bus
// اسم المجموعة: عبد الرحمن
// عدد الركاب: ٣٤
// الفندق: ثففق
// الشركة الناقلة: حافل
// رقم الباص: لققلق
// جوال السائق: ٠٤٥٥٩٤٥٥٤٥
// ملاحظات:



