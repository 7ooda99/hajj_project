import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syrian_hajj_project/core/constants.dart';
import 'dart:ui' as ui;
import 'package:syrian_hajj_project/helper/show_snack_bar.dart';
import 'package:syrian_hajj_project/pages/airport_page.dart';

import 'package:syrian_hajj_project/pages/form_page.dart';
import 'package:syrian_hajj_project/pages/widgets/airport_frame_widget.dart';
import 'package:intl/intl.dart';
import 'package:syrian_hajj_project/pages/widgets/tima_date_widget.dart';
import '../core/size_config.dart';

class AirportMainPage extends StatefulWidget {
  static String id = 'AirportMainPage';

  @override
  State<AirportMainPage> createState() => _AirportMainPageState();
}

class _AirportMainPageState extends State<AirportMainPage> {
  String role = 'user';
  String userName = '';
  bool isRoleLoading = true;
  String searchQuery = '';
  @override
  void initState() {
    super.initState();
    fetchUserRole();
  }

  void fetchUserRole() async {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      if (!mounted) return;
      setState(() {
        role = 'user';
        userName = '';
        isRoleLoading = false;
      });
      return;
    }

    try {
      final DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(userId).get();
      final data = docSnapshot.data();

      if (!mounted) return;
      setState(() {
        role = (data?['role'] ?? 'user').toString();
        userName = (data?['name'] ?? '').toString();
        print('User name: $userName');
        isRoleLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        role = 'user';
        userName = '';
        isRoleLoading = false;
      });
      print('Failed to fetch user role: $e');
    }
  }

  CollectionReference formInfo =
      FirebaseFirestore.instance.collection(kMessagesCollections);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController totalPassengersController = TextEditingController();

  final TextEditingController emailController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  final bool isTapped = false;

  bool isSearchTapped = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: kSecondaryColor,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'الرحلات',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(18),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isSearchTapped ? Icons.close_rounded : Icons.search_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                isSearchTapped = !isSearchTapped;
              });
              searchController.clear();
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                maxHeight: constraints.maxHeight,
              ),
              child: Column(
                children: [
                  Visibility(
                    visible: isSearchTapped,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        child: TextField(
                          controller: searchController,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (value) {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              searchQuery = value;
                            });
                          },
                          onTapOutside: (_) {
                            FocusScope.of(context).unfocus();
                          },
                          decoration: InputDecoration(
                            hintText: 'ابحث عن الرحلة',
                            hintStyle: TextStyle(
                              fontFamily: 'Cairo',
                              color: Colors.grey[500],
                              fontSize: 14,
                            ),
                            prefixIcon: Icon(Icons.search_rounded, color: kSecondaryColor, size: 20),
                            suffixIcon: IconButton(
                              icon: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: kSecondaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'بحث',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  searchQuery = searchController.text;
                                });
                              },
                            ),
                            filled: true,
                            fillColor: const Color(0xffF7F8FA),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(color: Color(0xffE2E5EA)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(color: Color(0xffE2E5EA)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(color: kSecondaryColor.withOpacity(0.7), width: 1.5),
                            ),
                          ),
                          textDirection: ui.TextDirection.rtl,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                  ),
                  Visibility(
                    visible: !isSearchTapped,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('formInfo')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Align(
                            alignment: Alignment.centerRight,
                            child: const Text(
                              'جاري الحساب...',
                              style: TextStyle(
                                  color: Colors.black, fontFamily: 'Cairo'),
                            ),
                          );
                        }

                        if (snapshot.hasError || !snapshot.hasData) {
                          return const SizedBox.shrink();
                        }

                        final docs = snapshot.data!.docs;
                        final totalPassengers = docs.fold<int>(
                          0,
                          (sum, doc) =>
                              sum +
                              (int.tryParse(
                                      doc['passenger']?.toString() ?? '0') ??
                                  0),
                        );

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'مجموع الحجاج : $totalPassengers',
                              style: const TextStyle(
                                  color: Colors.black, fontFamily: 'Cairo'),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Divider(
                    color: Colors.grey[300],
                    thickness: 1,
                    // height: 20,
                  ),
                  Expanded(child: allcards(context, searchQuery)),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
              onPressed: () {
                showCustomDialog(context, userName);
              },
              backgroundColor: kSecondaryColor,
              child: const Icon(
                Icons.add_rounded,
                size: 28,
                color: Colors.white,
              ),
            ),
    );
  }

  Widget allcards(BuildContext context, String? query) {
    Future<String?> fetchPassenger(String docId) async {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('formInfo')
          .doc(docId)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        return data?['passenger'] as String?;
      } else {
        return null;
      }
    }

    if (isRoleLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    String? userId = FirebaseAuth.instance.currentUser?.uid;

    Stream<QuerySnapshot> stream;

    if (query?.isNotEmpty ?? false) {
      stream = (role == 'admin')
          ? FirebaseFirestore.instance
              .collection(kMainCollections)
              .orderBy('travleName')
              .startAt([query]).endAt(['$query\uf8ff']).snapshots()
          : FirebaseFirestore.instance
              .collection(kMainCollections)
              .where('userId', isEqualTo: userId)
              .orderBy('travleName')
              .startAt([query]).endAt(['$query\uf8ff']).snapshots();
    } else {
      stream = (role == 'admin')
          ? FirebaseFirestore.instance
              .collection(kMainCollections)
              .orderBy('time', descending: true)
              .snapshots()
          : FirebaseFirestore.instance
              .collection(kMainCollections)
              .where('userId', isEqualTo: userId)
              .orderBy('time', descending: true)
              .snapshots();
    }

    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("خطأ: ${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.warning_amber_rounded, size: 50, color: Colors.grey),
                SizedBox(height: 10),
                Text(
                  'لا توجد بيانات متوفرة',
                  textDirection: ui.TextDirection.rtl,
                  style: TextStyle(
                      fontFamily: 'Cairo', fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        final docs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final DateTime date = data['time']?.toDate() ?? DateTime.now();
            final String formattedTime =
                DateFormat('yyyy/MM/dd - hh:mm a').format(date);
            final String travelId = data['travelId'];

            return GestureDetector(
              onTap: () => Get.off(() => AirportPage(
                    tripid: travelId,
                    tripName: data['travleName'],
                    role: role,
                    tripOwnerId: data['userId'],
                  )),
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    title: const Text(
                      'حذف الرحلة',
                      textDirection: ui.TextDirection.rtl,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xffD64545),
                      ),
                    ),
                    content: const Text(
                      'هل تريد بالفعل حذف الرحلة؟',
                      textDirection: ui.TextDirection.rtl,
                      style: TextStyle(fontFamily: 'Cairo', fontSize: 14),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'لا',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffD64545),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        ),
                        onPressed: () async {
                          Navigator.pop(context); // close the dialog first

                          final mainDocId = snapshot.data!.docs[index].id;
                          final travelId =
                              snapshot.data!.docs[index]['travelId'];

                          // Delete related documents first
                          final relatedDocs = await FirebaseFirestore.instance
                              .collection('formInfo')
                              .where('travelId', isEqualTo: travelId)
                              .get();

                          for (var doc in relatedDocs.docs) {
                            await FirebaseFirestore.instance
                                .collection('formInfo')
                                .doc(doc.id)
                                .delete();
                          }

                          // Now delete main document
                          await FirebaseFirestore.instance
                              .collection(kMainCollections)
                              .doc(mainDocId)
                              .delete();

                          showSnackBar(
                              context, 'تم حذف الرحلة والبيانات المرتبطة بها');
                        },
                        child: const Text(
                          'حذف',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header strip
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              kSecondaryColor,
                              kSecondaryColor.withOpacity(0.85),
                            ],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Passenger count
                            FutureBuilder<QuerySnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection('formInfo')
                                  .where('travelId', isEqualTo: travelId)
                                  .get(),
                              builder: (context, passengerSnapshot) {
                                if (passengerSnapshot.connectionState == ConnectionState.waiting) {
                                  return const SizedBox(
                                    width: 14, height: 14,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1.5, color: Colors.white70,
                                    ),
                                  );
                                }
                                int total = 0;
                                if (passengerSnapshot.hasData) {
                                  total = passengerSnapshot.data!.docs.fold<int>(
                                    0,
                                    (sum, doc) => sum + (int.tryParse(doc['passenger'].toString()) ?? 0),
                                  );
                                }
                                return Row(
                                  children: [
                                    const Icon(Icons.people_alt_rounded, size: 14, color: Colors.white70),
                                    const SizedBox(width: 4),
                                    Text(
                                      '$total حاج',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white70,
                                        fontFamily: 'Cairo',
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            // Admin: user name
                            if (role == 'admin')
                              Text(
                                data['userName'] ?? '',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.white60,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                          ],
                        ),
                      ),

                      // Trip name + passenger comparison
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Column(
                          children: [
                            Text(
                              data['travleName'] ?? 'غير محدد',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff2d2d2d),
                                fontFamily: 'Cairo',
                              ),
                              textAlign: TextAlign.center,
                            ),
                            // Passenger comparison badge
                            if (data['totalPassengers'] != null && data['totalPassengers'].toString().isNotEmpty)
                              FutureBuilder<QuerySnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('formInfo')
                                    .where('travelId', isEqualTo: travelId)
                                    .get(),
                                builder: (context, snap) {
                                  int entered = 0;
                                  if (snap.hasData) {
                                    entered = snap.data!.docs.fold<int>(
                                      0,
                                      (sum, doc) => sum + (int.tryParse(doc['passenger'].toString()) ?? 0),
                                    );
                                  }
                                  final int total = int.tryParse(data['totalPassengers'].toString()) ?? 0;
                                  final bool isComplete = entered >= total && total > 0;
                                  final double percent = total > 0 ? (entered / total).clamp(0.0, 1.0) : 0.0;

                                  return Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: isComplete
                                            ? const Color(0xff4a7c59).withOpacity(0.08)
                                            : const Color(0xffE8A838).withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isComplete
                                              ? const Color(0xff4a7c59).withOpacity(0.25)
                                              : const Color(0xffE8A838).withOpacity(0.25),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                isComplete ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                                                size: 16,
                                                color: isComplete ? const Color(0xff4a7c59) : const Color(0xffE8A838),
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                '$entered / $total حاج',
                                                style: TextStyle(
                                                  fontFamily: 'Cairo',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: isComplete ? const Color(0xff4a7c59) : const Color(0xffE8A838),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(4),
                                            child: LinearProgressIndicator(
                                              value: snap.connectionState == ConnectionState.waiting ? null : percent,
                                              minHeight: 5,
                                              backgroundColor: Colors.grey[200],
                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                isComplete ? const Color(0xff4a7c59) : const Color(0xffE8A838),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),

                      // Footer
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xffF7F8FA),
                          border: Border(
                            top: BorderSide(color: Colors.grey[200]!),
                          ),
                        ),
                        child: Row(
                          children: [
                            // Share button
                            Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  fetchTravelIds(userId!, index, role);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: Icon(
                                    Icons.share_rounded,
                                    size: 20,
                                    color: kSecondaryColor,
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Icon(Icons.calendar_today_rounded,
                                size: 13, color: Colors.grey[500]),
                            const SizedBox(width: 5),
                            Text(
                              formattedTime,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<String> fetchTravelIds(
      String userId, int index, String userRole) async {
    print('Fetching travel details for userId at index: $index');

    // Step 1: Fetch user trips
    var snapshot = userRole != 'admin'
        ? await FirebaseFirestore.instance
            .collection(kMainCollections)
            .where('userId', isEqualTo: userId)
            .orderBy('time', descending: true)
            .get()
        : await FirebaseFirestore.instance
            .collection(kMainCollections)
            .orderBy('time', descending: true)
            .get();

    if (index >= snapshot.docs.length) {
      print('Invalid index: $index');
      return '';
    }

    var selectedTripData = snapshot.docs[index].data();
    var travelId = selectedTripData['travelId'] as String;
    var travelName = selectedTripData['travleName'] ?? '';

    print('Selected travelId: $travelId');

    // Step 2: Fetch all messages for this travelId
    var querySnapshot = await FirebaseFirestore.instance
        .collection(kMessagesCollections)
        .where('travelId', isEqualTo: travelId)
        .get();

    if (querySnapshot.docs.isEmpty) {
      print('No data found for travelId: $travelId');
      showSnackBar(Get.context!, 'لا توجد بيانات لمشاركتها');
      return '';
    }

    // Step 3: Separate buses and deanas
    List<Map<String, dynamic>> busDataList = [];
    List<Map<String, dynamic>> deanaDataList = [];

    for (var doc in querySnapshot.docs) {
      var data = doc.data();
      if (data['type'] == 'باص') {
        busDataList.add(data);
      } else if (data['type'] == 'دينه') {
        deanaDataList.add(data);
      }
    }

    // Step 4: Build formatted share text
    StringBuffer allData = StringBuffer();
    String formattedDate = DateFormat('yyyy/MM/dd - hh:mm a').format(DateTime.now());
    final totalPassengers = selectedTripData['totalPassengers']?.toString() ?? '';

    allData.writeln('تقرير الرحلة: $travelName');
    allData.writeln('التاريخ: $formattedDate');
    allData.writeln('');

    int totalBusPassengers = 0;
    int totalDeanaPassengers = 0;

    // ── Buses section ──
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

    // ── Deanas section ──
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

    // ── Summary ──
    final int grandTotal = totalBusPassengers + totalDeanaPassengers;
    allData.writeln('--------------------');
    allData.writeln('✅ الملخص');
    if (busDataList.isNotEmpty)
      allData.writeln('باصات: ${busDataList.length}');
    if (deanaDataList.isNotEmpty)
      allData.writeln('دينات: ${deanaDataList.length}');
    allData.writeln('عدد الحجاج الاجمالي: $grandTotal');
    allData.writeln('');

    // Step 5: Share
    if (allData.isNotEmpty) {
      try {
        await Share.share(
          allData.toString(),
          subject: 'تقرير الرحلة $travelName',
        );
      } catch (e) {
        // Fallback: copy to clipboard if share plugin fails (e.g. Simulator)
        await Clipboard.setData(ClipboardData(text: allData.toString()));
        showSnackBar(
          Get.context!,
          'تم نسخ التقرير إلى الحافظة ✅',
        );
      }
    } else {
      showSnackBar(
        Get.context!,
        'لا توجد بيانات لمشاركتها',
      );
    }

    return travelId;
  }

// Helpers

  String formatBusData(Map<String, dynamic> data, String travelName) {
    return '';
  }

  String formatDeanaData(Map<String, dynamic> data, String travelName) {
    return '';
  }

  // Future<List<DocumentSnapshot>> fetchMessagesByTravelIds(List<String> travelIds) async {
  void showCustomDialog(BuildContext context, String userName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Directionality(
            textDirection: ui.TextDirection.rtl,
            child: Text(
              "إضافة رحلة جديدة",
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: kSecondaryColor,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Directionality(
                textDirection: ui.TextDirection.rtl,
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "رقم الرحلة",
                    labelStyle: TextStyle(
                      fontFamily: 'Cairo',
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: const Color(0xffF7F8FA),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xffE2E5EA)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xffE2E5EA)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: kSecondaryColor.withOpacity(0.7), width: 1.5),
                    ),
                  ),
                  style: const TextStyle(fontFamily: 'Cairo', fontSize: 14),
                ),
              ),
              const SizedBox(height: 14),
              Directionality(
                textDirection: ui.TextDirection.rtl,
                child: TextField(
                  controller: totalPassengersController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: "عدد الحجاج الإجمالي",
                    prefixIcon: Icon(Icons.people_alt_rounded, color: kSecondaryColor, size: 20),
                    labelStyle: TextStyle(
                      fontFamily: 'Cairo',
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: const Color(0xffF7F8FA),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xffE2E5EA)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xffE2E5EA)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: kSecondaryColor.withOpacity(0.7), width: 1.5),
                    ),
                  ),
                  style: const TextStyle(fontFamily: 'Cairo', fontSize: 14),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "إلغاء",
                style: TextStyle(
                  color: Color(0xffD64545),
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kSecondaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text(
                "إضافة",
                style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                if (nameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('يرجى تعبئة رقم الرحلة'),
                    duration: Duration(seconds: 2),
                  ));
                } else {
                  submitData();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void submitData() {
    Random random = new Random();
    int randomNumber = random.nextInt(1000000); // Generate a random number

    FirebaseFirestore.instance.collection(kMainCollections).add({
      'userId': FirebaseAuth.instance.currentUser?.uid,
      'travleName': nameController.text,
      'travelId': randomNumber.toString(),
      'userName': userName,
      'totalPassengers': totalPassengersController.text,
      "time": Timestamp.now(),
    }).then((result) {
      print("Data added successfully.");
      nameController.clear();
      totalPassengersController.clear();
      emailController.clear();
    }).catchError((error) {
      print("Failed to add data: $error");
    });
  }
}
