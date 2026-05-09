import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:share_plus/share_plus.dart';
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
  final String? role;
  final String? tripOwnerId;

  AirportPage({
    Key? key,
    this.tripName,
    this.tripid,
    this.role,
    this.tripOwnerId,
  }) : super(key: key);

  static String id = 'AirportPage';

  @override
  State<AirportPage> createState() => _AirportPageState();
}

class _AirportPageState extends State<AirportPage> {
  static const String busType = 'باص';
  static const String deanaType = 'دينه';

  CollectionReference formInfo =
      FirebaseFirestore.instance.collection(kMessagesCollections);
  int selectedValue = 0;
  late Stream<QuerySnapshot> itemStream;
  String tripType = busType;
  @override
  void initState() {
    super.initState();
    itemStream = getStreamBasedOnSelection(
        selectedValue); // Initialize with default stream
  }

  // final String ttripid=
  final bool isTapped = false;

  /// true only if the logged-in user is the one who created this trip.
  bool get _isOwner {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    return currentUid != null && currentUid == widget.tripOwnerId;
  }

  Future<void> _shareTrip() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection(kMessagesCollections)
        .where('travelId', isEqualTo: widget.tripid)
        .get();

    if (querySnapshot.docs.isEmpty) {
      showSnackBar(context, 'لا توجد بيانات لمشاركتها');
      return;
    }

    List<Map<String, dynamic>> busDataList = [];
    List<Map<String, dynamic>> deanaDataList = [];

    for (var doc in querySnapshot.docs) {
      var data = doc.data();
      if (data['type'] == busType) {
        busDataList.add(data);
      } else if (data['type'] == deanaType) {
        deanaDataList.add(data);
      }
    }

    StringBuffer allData = StringBuffer();
    String formattedDate = DateFormat('yyyy/MM/dd - hh:mm a').format(DateTime.now());

    allData.writeln('تقرير الرحلة: ${widget.tripName}');
    allData.writeln('التاريخ: $formattedDate');
    allData.writeln('');

    int totalBusPassengers = 0;
    int totalDeanaPassengers = 0;

    if (busDataList.isNotEmpty) {
      allData.writeln('🚌 الباصات (${busDataList.length})');
      allData.writeln('--------------------');

      for (int i = 0; i < busDataList.length; i++) {
        final data = busDataList[i];
        final passengers = int.tryParse(data['passenger']?.toString() ?? '0') ?? 0;
        totalBusPassengers += passengers;

        allData.writeln('باص ${i + 1}:');
        if ((data['busNumber'] ?? '').toString().isNotEmpty)
          allData.writeln('رقم الباص: ${data['busNumber']}');
        if ((data['group'] ?? '').toString().isNotEmpty)
          allData.writeln('اسم السائق: ${data['group']}');
        if ((data['hotel'] ?? '').toString().isNotEmpty)
          allData.writeln('هاتف السائق: ${data['hotel']}');
        if ((data['transfareCompany'] ?? '').toString().isNotEmpty)
          allData.writeln('الشركة الناقلة: ${data['transfareCompany']}');
        if ((data['groupName'] ?? '').toString().isNotEmpty)
          allData.writeln('المجموعة: ${data['groupName']}');
        if ((data['gps'] ?? '').toString().isNotEmpty)
          allData.writeln('الفندق: ${data['gps']}');
        allData.writeln('عدد الحجاج: $passengers');
        if ((data['notes'] ?? '').toString().trim().isNotEmpty)
          allData.writeln('ملاحظات: ${data['notes']}');
        allData.writeln('');
      }

      allData.writeln('إجمالي حجاج الباصات: $totalBusPassengers');
      allData.writeln('');
    }

    if (deanaDataList.isNotEmpty) {
      allData.writeln('🚚 الدينات (${deanaDataList.length})');
      allData.writeln('--------------------');

      for (int i = 0; i < deanaDataList.length; i++) {
        final data = deanaDataList[i];
        final passengers = int.tryParse(data['passenger']?.toString() ?? '0') ?? 0;
        totalDeanaPassengers += passengers;

        allData.writeln('دينة ${i + 1}:');
        if ((data['busNumber'] ?? '').toString().isNotEmpty)
          allData.writeln('رقم الدينة: ${data['busNumber']}');
        if ((data['group'] ?? '').toString().isNotEmpty)
          allData.writeln('اسم السائق: ${data['group']}');
        if ((data['hotel'] ?? '').toString().isNotEmpty)
          allData.writeln('جوال السائق: ${data['hotel']}');
        if ((data['groupName'] ?? '').toString().isNotEmpty)
          allData.writeln('المجموعة: ${data['groupName']}');
        if ((data['gps'] ?? '').toString().isNotEmpty)
          allData.writeln('الفندق: ${data['gps']}');
        if ((data['totalBags'] ?? '').toString().isNotEmpty)
          allData.writeln('عدد الحقائب: ${data['totalBags']}');
        if ((data['notes'] ?? '').toString().trim().isNotEmpty)
          allData.writeln('ملاحظات: ${data['notes']}');
        allData.writeln('');
      }

      allData.writeln('إجمالي حجاج الدينات: $totalDeanaPassengers');
      allData.writeln('');
    }

    final int grandTotal = totalBusPassengers + totalDeanaPassengers;
    allData.writeln('--------------------');
    allData.writeln('✅ الملخص');
    if (busDataList.isNotEmpty)
      allData.writeln('باصات: ${busDataList.length}');
    if (deanaDataList.isNotEmpty)
      allData.writeln('دينات: ${deanaDataList.length}');
    allData.writeln('عدد الحجاج الاجمالي: $grandTotal');
    allData.writeln('');

    await Share.share(
      allData.toString(),
      subject: 'تقرير الرحلة ${widget.tripName}',
    );
  }

  @override
  Widget build(BuildContext context) {
    print('the trip name is: ${widget.tripid}');
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Get.off(() => AirportMainPage()),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
        ),
        backgroundColor: kSecondaryColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'رحلة ${widget.tripName}',
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _shareTrip,
            icon: const Icon(Icons.share_rounded, color: Colors.white, size: 22),
            tooltip: 'مشاركة بيانات الرحلة',
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(18),
          ),
        ),
      ),
      body: Column(
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
                    Text('دينات',
                        style: TextStyle(
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
                    Text('باصات',
                        style: TextStyle(
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
                  tripType = value == 0 ? deanaType : busType;
                });
              },
            ),
          ),
          Expanded(child: allcards(context, tripType)),
        ],
      ),

      floatingActionButton: _isOwner ? buildSpeedDial() : null,
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

  Widget allcards(BuildContext context, String tripType) {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    print('current user id: $userId');
    print('the trip id is: ${widget.tripid}');

    // Admin sees all entries for this trip; regular user sees only their own.
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collection(kMessagesCollections)
        .where('travelId', isEqualTo: widget.tripid)
        .where('type', isEqualTo: tripType)
        .orderBy('time', descending: true);

    if (widget.role != 'admin') {
      query = query.where('userId', isEqualTo: userId);
    }

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('snapshot error: ${snapshot.error}');
          return Text("Error: ${snapshot.error}");
        }
        if (!snapshot.hasData) {
          return ModalProgressHUD(
            inAsyncCall: true,
            child: const Center(
              child: Text('جاري التحميل....'),
            ),
          ); // LodingView
        } else {
          // Sort locally: unsent first, then by time (already sorted by query)
          final docs = snapshot.data!.docs.toList();
          docs.sort((a, b) {
            final aData = a.data() as Map<String, dynamic>?;
            final bData = b.data() as Map<String, dynamic>?;
            final aSent = aData?['isSent'] == true ? 1 : 0;
            final bSent = bData?['isSent'] == true ? 1 : 0;
            if (aSent != bSent) return aSent.compareTo(bSent);
            return 0; // keep original time order within same group
          });

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: _isOwner ? () {
                  final doc = docs[index];
                  if (tripType == deanaType) {
                    Get.to(
                      () => DeanaFormPage(
                        gpsControllerText: doc['gps'],
                        passengerControllerText: doc['passenger'],
                        hotelControllerText: doc['hotel'],
                        groupControllerText: doc['group'],
                        notesControllerText: doc['notes'],
                        busNumberText: doc['busNumber'],
                        groupNameText: doc['groupName'],
                        totalBagsText: (doc.data() as Map<String, dynamic>?)
                                    ?.containsKey('totalBags') ==
                                true
                            ? doc['totalBags']
                            : '',
                        tripid: doc.id,
                        buttonText: 'تعديل',
                        title: "التعديل على الدينة الحالية",
                        travelId: widget.tripid ?? '',
                        userRole: widget.role,
                      ),
                    );
                  } else {
                    Get.to(
                      () => FormPage(
                        gpsControllerText: doc['gps'],
                        passengerControllerText: doc['passenger'],
                        hotelControllerText: doc['hotel'],
                        groupControllerText: doc['group'],
                        notesControllerText: doc['notes'],
                        busNumberText: doc['busNumber'],
                        groupNameText: doc['groupName'],
                        transfareCompanyText:
                            (doc.data() as Map<String, dynamic>?)
                                        ?.containsKey('transfareCompany') ==
                                    true
                                ? doc['transfareCompany']
                                : '',
                        tripid: doc.id,
                        buttonText: 'تعديل',
                        title: "التعديل على الرحلة الحالية",
                        travelId: widget.tripid ?? '',
                        userRole: widget.role,
                      ),
                    );
                  }
                } : null,
                onLongPress: _isOwner ? () {
                  final docId = docs[index].id;
                  final docData = docs[index].data() as Map<String, dynamic>?;
                  final bool currentIsSent = docData?['isSent'] == true;

                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (_) => Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 40, height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ListTile(
                            leading: Icon(
                              currentIsSent ? Icons.undo_rounded : Icons.check_circle_outline_rounded,
                              color: currentIsSent ? Colors.orange : const Color(0xff2e7d32),
                              size: 28,
                            ),
                            title: Text(
                              currentIsSent ? 'إلغاء الإرسال' : 'تم الإرسال',
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            onTap: () {
                              FirebaseFirestore.instance
                                  .collection(kMessagesCollections)
                                  .doc(docId)
                                  .update({'isSent': !currentIsSent});
                              Navigator.pop(context);
                              showSnackBar(
                                context,
                                currentIsSent ? 'تم إلغاء حالة الإرسال' : 'تم تحديده كمرسل ✅',
                              );
                            },
                          ),
                          const Divider(height: 1),
                          ListTile(
                            leading: const Icon(
                              Icons.delete_outline_rounded,
                              color: Color(0xffD64545),
                              size: 28,
                            ),
                            title: const Text(
                              'حذف',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Color(0xffD64545),
                              ),
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            onTap: () {
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  title: const Text(
                                    'حذف الرحلة',
                                    textDirection: ui.TextDirection.rtl,
                                    style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xffD64545)),
                                  ),
                                  content: const Text('هل تريد بالفعل حذف الرحلة؟', textDirection: ui.TextDirection.rtl, style: TextStyle(fontFamily: 'Cairo', fontSize: 14)),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('لا', style: TextStyle(color: Colors.grey[700], fontFamily: 'Cairo', fontWeight: FontWeight.w600)),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xffD64545),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                      ),
                                      onPressed: () {
                                        FirebaseFirestore.instance.collection(kMessagesCollections).doc(docId).delete();
                                        showSnackBar(context, 'تم حذف الرحلة');
                                        Navigator.pop(context);
                                      },
                                      child: const Text('حذف', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  );
                } : null,
                child: cardDetails(docs[index], tripType),
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
    String formattedDateTime = DateFormat('yyyy/MM/dd  -  hh:mm a').format(d);
    if (type == busType) {
      return _buildBusCard(docment, formattedDateTime);
    } else {
      return _buildDeanaCard(docment, formattedDateTime);
    }
  }

  Widget _buildBusCard(DocumentSnapshot doc, String time) {
    final data = doc.data() as Map<String, dynamic>?;
    final bool isSent = data?['isSent'] == true;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isSent ? const Color(0xffE8F5E9) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isSent ? 0.05 : 0.1),
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
              color: isSent ? const Color(0xff388E3C) : kSecondaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.directions_bus,
                          color: Colors.white, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        '${doc['busNumber']}',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      if (isSent)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check_circle, color: Colors.white, size: 12),
                              SizedBox(width: 4),
                              Text('تم الإرسال', style: TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      if (isSent) const SizedBox(width: 8),
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child:
                        _infoTile(Icons.hotel, 'الفندق', doc['gps'].toString()),
                  ),
                  Container(width: 1, height: 50, color: Colors.grey[200]),
                  Expanded(
                    child: _infoTile(
                        Icons.people, 'الحجاج', doc['passenger'].toString()),
                  ),
                  Container(width: 1, height: 50, color: Colors.grey[200]),
                  Expanded(
                    child:
                        _infoTile(Icons.person, 'السائق', doc['group'] ?? ''),
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
                    style: const TextStyle(
                        fontSize: 11, color: Colors.grey, fontFamily: 'Cairo'),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => _shareItem(doc, busType),
                    child: Icon(Icons.share_rounded, size: 16, color: kSecondaryColor),
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
    final data = doc.data() as Map<String, dynamic>?;
    final bool isSent = data?['isSent'] == true;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isSent ? const Color(0xffE8F5E9) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isSent ? 0.05 : 0.1),
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
              color: isSent ? const Color(0xff2E7D32) : const Color(0xff4a7c59),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.local_taxi,
                          color: Colors.white, size: 18),
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
                  Row(
                    children: [
                      if (isSent)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check_circle, color: Colors.white, size: 12),
                              SizedBox(width: 4),
                              Text('تم الإرسال', style: TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      if (isSent) const SizedBox(width: 8),
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: _infoTile(
                        Icons.person_outline, 'السائق', doc['group'] ?? ''),
                  ),
                  Container(width: 1, height: 50, color: Colors.grey[200]),
                  Expanded(
                    child: _infoTile(
                        Icons.phone_android, 'الجوال', doc['hotel'].toString()),
                  ),
                ],
              ),
            ),
            if ((doc['notes'] ?? '').toString().isNotEmpty)
              Container(
                width: double.infinity,
                color: Colors.amber[50],
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.notes, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        doc['notes'].toString(),
                        style:
                            const TextStyle(fontSize: 11, fontFamily: 'Cairo'),
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
                    style: const TextStyle(
                        fontSize: 11, color: Colors.grey, fontFamily: 'Cairo'),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => _shareItem(doc, deanaType),
                    child: const Icon(Icons.share_rounded, size: 16, color: Color(0xff4a7c59)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _shareItem(DocumentSnapshot doc, String type) async {
    final data = doc.data() as Map<String, dynamic>;
    StringBuffer text = StringBuffer();

    final Timestamp t = data['time'];
    final String formattedDate = DateFormat('yyyy/MM/dd - hh:mm a').format(t.toDate());

    text.writeln('رحلة: ${widget.tripName}');
    text.writeln('التاريخ: $formattedDate');
    text.writeln('');

    if (type == busType) {
      text.writeln('🚌 بيانات الباص');
      text.writeln('--------------------');
      if ((data['busNumber'] ?? '').toString().isNotEmpty)
        text.writeln('رقم الباص: ${data['busNumber']}');
      if ((data['group'] ?? '').toString().isNotEmpty)
        text.writeln('اسم السائق: ${data['group']}');
      if ((data['hotel'] ?? '').toString().isNotEmpty)
        text.writeln('هاتف السائق: ${data['hotel']}');
      if ((data['transfareCompany'] ?? '').toString().isNotEmpty)
        text.writeln('الشركة الناقلة: ${data['transfareCompany']}');
      if ((data['groupName'] ?? '').toString().isNotEmpty)
        text.writeln('المجموعة: ${data['groupName']}');
      if ((data['gps'] ?? '').toString().isNotEmpty)
        text.writeln('الفندق: ${data['gps']}');
      text.writeln('عدد الحجاج: ${data['passenger'] ?? ''}');
    } else {
      text.writeln('🚚 بيانات الدينة');
      text.writeln('--------------------');
      if ((data['busNumber'] ?? '').toString().isNotEmpty)
        text.writeln('رقم الدينة: ${data['busNumber']}');
      if ((data['group'] ?? '').toString().isNotEmpty)
        text.writeln('اسم السائق: ${data['group']}');
      if ((data['hotel'] ?? '').toString().isNotEmpty)
        text.writeln('جوال السائق: ${data['hotel']}');
      if ((data['groupName'] ?? '').toString().isNotEmpty)
        text.writeln('المجموعة: ${data['groupName']}');
      if ((data['gps'] ?? '').toString().isNotEmpty)
        text.writeln('الفندق: ${data['gps']}');
      if ((data['totalBags'] ?? '').toString().isNotEmpty)
        text.writeln('عدد الحقائب: ${data['totalBags']}');
    }

    if ((data['notes'] ?? '').toString().trim().isNotEmpty)
      text.writeln('ملاحظات: ${data['notes']}');

    await Share.share(text.toString());
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 18, color: kSecondaryColor),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
              fontSize: 10, color: Colors.grey[500], fontFamily: 'Cairo'),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      icon: Icons.add_rounded,
      activeIcon: Icons.close_rounded,
      spacing: 3,
      spaceBetweenChildren: 8,
      buttonSize: const Size(60, 60),
      visible: true,
      closeManually: false,
      curve: Curves.easeInOut,
      overlayColor: Colors.black,
      overlayOpacity: 0.3,
      tooltip: 'Options',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: kSecondaryColor,
      foregroundColor: Colors.white,
      elevation: 8.0,
      shape: const CircleBorder(),
      children: [
        SpeedDialChild(
          child: const Icon(Icons.local_shipping_rounded, color: Colors.white),
          backgroundColor: const Color(0xff4a7c59),
          label: 'إضافة دينة جديدة',
          labelStyle: const TextStyle(
              fontSize: 15, fontFamily: 'Cairo', fontWeight: FontWeight.w600),
          labelBackgroundColor: Colors.white,
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
          child: const Icon(Icons.directions_bus_rounded, color: Colors.white),
          backgroundColor: kSecondaryColor,
          label: 'اضافة باص جديد',
          labelStyle: const TextStyle(
              fontSize: 15, fontFamily: 'Cairo', fontWeight: FontWeight.w600),
          labelBackgroundColor: Colors.white,
          onTap: () {
            Get.to(
              () => FormPage(
                tripid: '',
                title: 'إضافة باص جديد',
                buttonText: 'إضافة',
                travelId: widget.tripid ?? '',
              ),
            );
          },
        ),
      ],
    );
  }

  Stream<QuerySnapshot> getStreamBasedOnSelection(int value) {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    String typeFilter = value == 0 ? deanaType : busType;
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