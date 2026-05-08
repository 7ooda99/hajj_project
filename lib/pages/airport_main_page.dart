import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();

    setState(() {
      role = docSnapshot.get('role') ?? 'user';
      userName = docSnapshot.get('name') ?? '';
      print('User name: $userName');
      isRoleLoading = false;
    });
  }

  CollectionReference formInfo =
      FirebaseFirestore.instance.collection(kMessagesCollections);

  final TextEditingController nameController = TextEditingController();

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
    // automaticallyImplyLeading: false,
    iconTheme: const IconThemeData(
    color: Colors.black, //change your color here
    ),
    backgroundColor: kMainColor,
    centerTitle: true,
    title: const Text(
    'الرحلات',
    style: TextStyle(color: Colors.black, fontFamily: 'Cairo'),
    ),
    actions: [
    IconButton(
    icon: const Icon(Icons.search),
    onPressed: () {
    // Handle the search button tap
    // You can toggle the visibility of the search bar here
    setState(() {
    isSearchTapped = !isSearchTapped;
    });
    searchController.clear();
    print('Search button tapped');
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
                    child: Directionality(
                      textDirection: ui.TextDirection.rtl,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
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
                            hintStyle: const TextStyle(
                              fontFamily: 'Cairo',
                              color: Colors.black,
                            ),
                            suffixIcon: IconButton(
                              icon: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'بحث',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    color: Colors.black,
                                    fontSize: 12,
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
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                          ),
                          textDirection: ui.TextDirection.rtl,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !isSearchTapped,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('formInfo').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Align(
                            alignment: Alignment.centerRight,
                            child: const Text(
                              'جاري الحساب...',
                              style: TextStyle(color: Colors.black, fontFamily: 'Cairo'),
                            ),
                          );
                        }

                        if (snapshot.hasError || !snapshot.hasData) {
                          return const SizedBox.shrink();
                        }

                        final docs = snapshot.data!.docs;
                        final totalPassengers = docs.fold<int>(
                          0,
                              (sum, doc) => sum + (int.tryParse(doc['passenger']?.toString() ?? '0') ?? 0),
                        );

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'مجموع الحجاج : $totalPassengers',
                              style: const TextStyle(color: Colors.black, fontFamily: 'Cairo'),
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

      floatingActionButton: role != 'admin' ? FloatingActionButton(
        onPressed: () {
          showCustomDialog(context, userName);
          // Get.off(
          //       () => FormPage(
          //     tripid: '',
          //     title: 'إضافة رحلة جديدة',
          //     buttonText: 'إضافة',
          //   ),);
          // transition: Transition.rightToLeft,
          // duration: const Duration(milliseconds: 500));
        },
        backgroundColor: kMainColor,
        child: const Icon(
          Icons.edit_outlined,
          size: 30,
          color: Colors.black,
        ),
      ) : SizedBox.shrink(),
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
          .startAt([query])
          .endAt(['$query\uf8ff'])
          .snapshots()
          : FirebaseFirestore.instance
          .collection(kMainCollections)
          .where('userId', isEqualTo: userId)
          .orderBy('travleName')
          .startAt([query])
          .endAt(['$query\uf8ff'])
          .snapshots();
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
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 18, color: Colors.grey),
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
            final String formattedTime = DateFormat('yyyy/MM/dd - hh:mm a').format(date);
            final String travelId = data['travelId'];

            return GestureDetector(
              onTap: () => Get.off(() => AirportPage(
                tripid: travelId,
                tripName: data['travleName'],
                role: role,
              )),
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
                        child: const Text('لا', style: TextStyle(
                          color: Colors.black,
                        ),),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context); // close the dialog first

                          final mainDocId = snapshot.data!.docs[index].id;
                          final travelId = snapshot.data!.docs[index]['travelId'];

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

                          showSnackBar(context, 'تم حذف الرحلة والبيانات المرتبطة بها');
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
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                padding: const EdgeInsets.all(10),
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  border: Border(left: BorderSide(color: kMainColor, width: 5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FutureBuilder<QuerySnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('formInfo')
                              .where('travelId', isEqualTo: travelId)
                              .get(),
                          builder: (context, passengerSnapshot) {
                            if (passengerSnapshot.connectionState == ConnectionState.waiting) {
                              return SizedBox(
                                  width: 15, height: 15, child: CircularProgressIndicator(strokeWidth: 2));
                            }

                            if (!passengerSnapshot.hasData || passengerSnapshot.data!.docs.isEmpty) {
                              return const Text(
                                'الحجاج: 0',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              );
                            }

                            final docs = passengerSnapshot.data!.docs;
                            int totalPassengers = docs.fold<int>(
                              0,
                                  (sum, doc) => sum + (int.tryParse(doc['passenger'].toString()) ?? 0),
                            );
                            return Text(
                              'الحجاج: $totalPassengers',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                        if (role == 'admin')
                          Text(
                            data['userName'] ?? 'غير محدد',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          data['travleName'] ?? 'غير محدد',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontFamily: 'Cairo',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const Divider(thickness: 1, height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Material(
                          borderRadius: BorderRadius.circular(20),

                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              fetchTravelIds(userId!, index, role);
                            },
                            child: Icon(
                              Icons.share,
                              size: 25,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        // InkWell(
                        //   onTap: () => fetchTravelIds(userId!, index, role),
                        //   child: Icon(
                        //     Icons.share,
                        //     size: 20,
                        //     color: Colors.grey[600],
                        //   ),
                        // ),
                        Spacer(),
                        Text(
                          formattedTime,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                        Spacer(),
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
  Future<String> fetchTravelIds(String userId, int index, String userRole) async {
    print('Fetching travel details for userId at index: $index');

    // Step 1: Fetch user trips
    var snapshot = userRole != 'admin' ?
    await FirebaseFirestore.instance
        .collection(kMainCollections)
        .where('userId', isEqualTo: userId)
        .orderBy('time', descending: true)
        .get() :
    await FirebaseFirestore.instance
        .collection(kMainCollections)
        .orderBy('time', descending: true)
        .get()
    ;

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

    // Step 4: Format bus data
    StringBuffer allData = StringBuffer();


    if (busDataList.isNotEmpty) {
      allData.writeln('🚌 بيانات الباصات للرحلة : $travelName\n');
      String formattedDate = DateFormat('yyyy/MM/dd').format(DateTime.now());
      allData.writeln('🕓 التاريخ: $formattedDate\n');
      for (var data in busDataList) {
        allData.writeln(formatBusData(data, travelName));
      }
    }

    // Step 5: Format deana data
    if (deanaDataList.isNotEmpty) {
      allData.writeln('\n🚚 بيانات الديانات للرحلة : $travelName\n');
      for (var data in deanaDataList) {
        allData.writeln(formatDeanaData(data, travelName));
      }
    }

    // Step 6: Share
    if (allData.isNotEmpty) {
      Share.share(
        allData.toString(),
        subject: 'تفاصيل الرحلة $travelName',
      );
    } else {
      print('No valid documents to share for travelId: $travelId');
      showSnackBar(
        Get.context!,
        'لا توجد بيانات لمشاركتها',
      );
    }

    return travelId;
  }

// Helpers

  String formatBusData(Map<String, dynamic> data, String travelName) {
    String formattedDate = DateFormat('yyyy/MM/dd').format(
      (data['time'] as Timestamp).toDate(),
    );
    return '''
اسم السائق : ${data['group'] ?? ''}
هاتف السائق : ${data['hotel'] ?? ''}
رقم الباص : ${data['busNumber'] ?? ''}
الشركة الناقلة : ${data['transfareCompany'] ?? ''}
الفندق : ${data['gps'] ?? ''}
اسم المجموعة / التكتل : ${data['groupName'] ?? ''}
عدد الحجاج : ${data['passenger'] ?? ''}
الملاحظات : ${data['notes'] ?? ''}
--------------------
''';
  }



  String formatDeanaData(Map<String, dynamic> data, String travelName) {
    String formattedDate = DateFormat('yyyy/MM/dd').format(
      (data['time'] as Timestamp).toDate(),
    );
    return '''
اسم السائق: ${data['group'] ?? ''}
جوال السائق: ${data['hotel'] ?? ''}
رقم الدينه: ${data['busNumber'] ?? ''}
اسم الفندق: ${data['gps'] ?? ''}
اسم المجموعة: ${data['groupName'] ?? ''}
عدد الحقائب: ${data['totalBags'] ?? ''}
ملاحظات: ${data['notes'] ?? ''}
--------------------
''';
  }

  // Future<List<DocumentSnapshot>> fetchMessagesByTravelIds(List<String> travelIds) async {
  void showCustomDialog(BuildContext context, String userName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Directionality(
              textDirection: ui.TextDirection.rtl,
              child: Text("ادخال رقم الرحلة")),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Directionality(
                textDirection: ui.TextDirection.rtl,
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(
                      fontFamily: 'Cairo',
                      color: Colors.black,
                    ),
                    labelText: "رقم الرحلة",
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("الغاء",
                  style: TextStyle(
                    color: Colors.red,
                  )),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text("إضافة",
                  style: TextStyle(
                    color: Colors.green,
                  )),

              onPressed: () {
                if (nameController.text.isEmpty) {
                  // Show an alert or another error message if the field is empty
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('يرجى تعبئة رقم الرحلة'),
                    duration: Duration(seconds: 2),
                  ));
                } else {
                  submitData(); // Pass the data to be submitted
                  Navigator.of(context)
                      .pop(); // Close the dialog after data submission
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
      'userName' : userName,
      "time": Timestamp.now(),
    }).then((result) {
      print("Data added successfully.");
      nameController.clear(); // Clear the text fields after submission
      emailController.clear();
    }).catchError((error) {
      print("Failed to add data: $error");
    });
  }
}


