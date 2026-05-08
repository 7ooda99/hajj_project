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
import 'package:syrian_hajj_project/pages/widgets/custom_dropdown_field.dart';

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

  // ── Extra groups added inline ──
  final List<Map<String, String>> _extraGroups = [];

  @override
  void initState() {
    super.initState();
    widget.transfareCompany.text = widget.transfareCompany.text.isNotEmpty ? widget.transfareCompany.text : 'حافل';
  }
  String? selectedHotel;

  // ── Build the notes string including extra groups ──
  String _buildNotesWithGroups() {
    String notes = widget.notesController.text;
    if (_extraGroups.isNotEmpty) {
      for (var g in _extraGroups) {
        notes += 'مجموعة اضافية :- \n اسم المجموعة : ${g['name']} \n العدد : ${g['count']} \nالفندق : ${g['hotel']}\n ';
      }
    }
    return notes;
  }

  // ── Show bottom sheet to add or edit a group ──
  void _showAddGroupSheet({int? editIndex}) {
    final isEditing = editIndex != null;
    final existing = isEditing ? _extraGroups[editIndex] : null;

    String? sheetGroupName = existing?['name'];
    String? sheetHotelName = existing?['hotel'];
    final countController = TextEditingController(text: existing?['count'] ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Handle bar
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Title
                    Row(
                      textDirection: ui.TextDirection.rtl,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: kSecondaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isEditing ? Icons.edit_rounded : Icons.group_add_rounded,
                            color: kSecondaryColor,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          isEditing ? 'تعديل المجموعة' : 'إضافة مجموعة',
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Group name dropdown
                    CustomDropdownField<String>(
                      labelText: 'اسم المجموعة',
                      value: sheetGroupName,
                      items: [
                        'المحراب', 'القصواء', 'عباد الرحمن', 'البراق',
                        'الرحاب الطاهره', 'شذا مكة', 'العمري', 'بشروا',
                        'وتعاونوا', 'الركب الميمون', 'الفتح المبين', 'الماسي',
                        'المشاعر', 'الاجابة', 'رؤيا', 'ياسر جود - الحمد',
                        'وليد قدو - العلياء', 'فيصل حجى سلامه - الكلمة الطيبة',
                        'إسطنبول', 'الرضوان', 'العلياء', 'الخيرات',
                        'واعتصموا', 'عطاء', 'نسك', 'الأخلاء', 'النخبة',
                      ].map((label) => DropdownMenuItem(
                        alignment: Alignment.bottomRight,
                        value: label,
                        child: Text(label, textDirection: TextDirection.rtl),
                      )).toList(),
                      onChanged: (value) {
                        setSheetState(() {
                          sheetGroupName = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),

                    // Hotel + count row
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: CustomDropdownField<String>(
                            labelText: 'الفندق',
                            value: sheetHotelName,
                            items: [
                              'إبراهيم علي العقل (هياء) - 10011798',
                              'افق الخيمة - 10012747',
                              'الرسالة الماسي - 10007923',
                              'بركة اليقين - 10010172',
                              'جاد كدي - 10007042',
                              'جوهرة ال صبغة 1 - 10012631',
                              'جوهرة النزهة - 10011735',
                              'دفلى 2 - 10011067',
                              'زاد اليقين - 10010919',
                              'سنود الريان - 10001983',
                              'سنود المشاعر - 10012634',
                              'شعائر الحياة - 10007459',
                              'عفراء - 10000993',
                              'فجر النسك - 10011289',
                              'فيلفيت ان - 10012235',
                              'فيوليت 3 - 10000966',
                              'مرجانة الحجاز - 10012908',
                              'منصور الثبيتي (اورينز) - 10011487',
                              'ميزاب الخير - 10010182',
                              'نرجس الحديقة - 10007206',
                            ].map((label) => DropdownMenuItem(
                              alignment: Alignment.bottomRight,
                              value: label,
                              child: Text(label, textDirection: TextDirection.rtl),
                            )).toList(),
                            onChanged: (value) {
                              setSheetState(() {
                                sheetHotelName = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: CustomSmallTextField(
                            controller: countController,
                            onSaved: (_) {},
                            lableText: 'العدد',
                            inputType: TextInputType.number,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(ctx),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey[400]!),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text(
                              'إلغاء',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (sheetGroupName == null || sheetGroupName!.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('يرجى اختيار اسم المجموعة')),
                                );
                                return;
                              }
                              final groupData = {
                                'name': sheetGroupName ?? '',
                                'hotel': sheetHotelName ?? '',
                                'count': countController.text,
                              };
                              setState(() {
                                if (isEditing) {
                                  _extraGroups[editIndex] = groupData;
                                } else {
                                  _extraGroups.add(groupData);
                                }
                              });
                              Navigator.pop(ctx);
                            },
                            icon: Icon(isEditing ? Icons.save_rounded : Icons.check_rounded, size: 20),
                            label: Text(
                              isEditing ? 'حفظ التعديل' : 'إضافة',
                              style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kSecondaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ── Build extra-group cards ──
  Widget _buildExtraGroupCards() {
    if (_extraGroups.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        _sectionHeader(Icons.groups_rounded, 'المجموعات الإضافية (${_extraGroups.length})'),
        const SizedBox(height: 4),
        ..._extraGroups.asMap().entries.map((entry) {
          final i = entry.key;
          final g = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              decoration: BoxDecoration(
                color: kSecondaryColor.withOpacity(0.06),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: kSecondaryColor.withOpacity(0.2)),
              ),
              child: ListTile(
                dense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                title: Text(
                  g['name'] ?? '',
                  textDirection: ui.TextDirection.rtl,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  '${g['hotel']!.isNotEmpty ? g['hotel'] : 'بدون فندق'}  •  ${g['count']!.isNotEmpty ? '${g['count']} حاج' : 'بدون عدد'}',
                  textDirection: ui.TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                leading: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.group_rounded, size: 18, color: kSecondaryColor),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Edit button
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        _showAddGroupSheet(editIndex: i);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: kSecondaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.edit_rounded, size: 16, color: kSecondaryColor),
                      ),
                    ),
                    const SizedBox(width: 6),
                    // Delete button
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        setState(() {
                          _extraGroups.removeAt(i);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xffD64545).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close_rounded, size: 16, color: Color(0xffD64545)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _sectionHeader(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        textDirection: ui.TextDirection.rtl,
        children: [
          Icon(icon, size: 18, color: kSecondaryColor),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Divider(color: Colors.grey[300])),
        ],
      ),
    );
  }

  void updateForm() {
    final group = widget.groupController.text;
    final hotel = widget.hotelController.text;
    final passenger = widget.passengerController.text;
    final groupName = widget.groupName.text;
    final busNumber = widget.busNumber.text;
    final gps = widget.gpsController.text;
    final notes = _buildNotesWithGroups();
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
    final notes = _buildNotesWithGroups();
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
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: kSecondaryColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
        ),
        title: Text(
          widget.title!,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(18),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          children: [
            const VerticalSpace(2),
            _sectionHeader(Icons.directions_bus, 'بيانات الباص'),
            const VerticalSpace(1),
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
CustomDropdownField<String>(
              labelText: 'اسم المجموعة/التكتل',
              value: widget.groupName.text.isNotEmpty ? widget.groupName.text : null,
              items: [
                'المحراب', 'القصواء', 'عباد الرحمن', 'البراق',
                'الرحاب الطاهره', 'شذا مكة', 'العمري', 'بشروا',
                'وتعاونوا', 'الركب الميمون', 'الفتح المبين', 'الماسي',
                'المشاعر', 'الاجابة', 'رؤيا', 'ياسر جود - الحمد',
                'وليد قدو - العلياء', 'فيصل حجى سلامه - الكلمة الطيبة',
                'إسطنبول', 'الرضوان', 'العلياء', 'الخيرات',
                'واعتصموا', 'عطاء', 'نسك', 'الأخلاء', 'النخبة',
              ].map((label) => DropdownMenuItem(
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
            const VerticalSpace(2),
            Row(
              children: [
                Expanded(
                  child: CustomDropdownField<String>(
                    labelText: 'الفندق',
                    value: widget.gpsController.text.isNotEmpty ? widget.gpsController.text : null,
                     items: [
                       'إبراهيم علي العقل (هياء) - 10011798',
                       'افق الخيمة - 10012747',
                       'الرسالة الماسي - 10007923',
                       'بركة اليقين - 10010172',
                       'جاد كدي - 10007042',
                       'جوهرة ال صبغة 1 - 10012631',
                       'جوهرة النزهة - 10011735',
                       'دفلى 2 - 10011067',
                       'زاد اليقين - 10010919',
                       'سنود الريان - 10001983',
                       'سنود المشاعر - 10012634',
                       'شعائر الحياة - 10007459',
                       'عفراء - 10000993',
                       'فجر النسك - 10011289',
                       'فيلفيت ان - 10012235',
                       'فيوليت 3 - 10000966',
                       'مرجانة الحجاز - 10012908',
                       'منصور الثبيتي (اورينز) - 10011487',
                       'ميزاب الخير - 10010182',
                       'نرجس الحديقة - 10007206',
                     ].map((label) => DropdownMenuItem(
                      alignment: Alignment.bottomRight,
                      value: label,
                      child: Text(label, textDirection: TextDirection.rtl),
                    )).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        widget.gpsController.text = newValue ?? '';
                      });
                    },
                    onSaved: (value) {
                      formInfo.add({'gps': value});
                    },
                  ),
                ),
                Expanded(
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
              ],
            ),



            const VerticalSpace(2),

            // ── Extra group cards ──
            _buildExtraGroupCards(),

            // ── Add group button ──
            GestureDetector(
              onTap: _showAddGroupSheet,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: kSecondaryColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: kSecondaryColor.withOpacity(0.35),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'أضف مجموعة إضافية',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: kSecondaryColor,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.add_circle_outline_rounded,
                      color: kSecondaryColor,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
            const VerticalSpace(2),

            CustomTextField(
              controller: widget.notesController,
              onSaved: (data) {
                formInfo.add({'notes': data});
              },
              lableText: 'ملاحظات',
              maxLines: 7,
            ),

            const VerticalSpace(2),
            // Admin can edit but not add new records
            (widget.userRole == 'admin' && widget.buttonText == 'إضافة')
            ? const SizedBox.shrink()
            : CustomButton(
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

// الرحلة: ٢
// نوع الرحلة: bus
// اسم المجموعة: عبد الرحمن
// عدد الركاب: ٣٤
// الفندق: ثففق
// الشركة الناقلة: حافل
// رقم الباص: لققلق
// جوال السائق: ٠٤٥٥٩٤٥٥٤٥
// ملاحظات:



