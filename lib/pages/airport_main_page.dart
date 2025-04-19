

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:syrian_hajj_project/core/constants.dart';
import 'dart:ui' as ui;
import 'package:syrian_hajj_project/helper/show_snack_bar.dart';
import 'package:syrian_hajj_project/pages/airport_page.dart';

import 'package:syrian_hajj_project/pages/form_page.dart';
import 'package:syrian_hajj_project/pages/widgets/airport_frame_widget.dart';
import 'package:intl/intl.dart';
import '../core/size_config.dart';

class AirportMainPage extends StatelessWidget {
  CollectionReference formInfo =
  FirebaseFirestore.instance.collection(kMessagesCollections);
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  static String id = 'AirportMainPage';

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
          'الرحلات',
          style: TextStyle(color: Colors.black, fontFamily: 'Cairo'),
        ),

      ),
      body: allcards(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCustomDialog(
              context
          );
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
      ),
    );
  }

  Widget allcards(BuildContext context) {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    print('current user id: ${FirebaseAuth.instance.currentUser?.uid}');
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(kMainCollections)
          .where('userId', isEqualTo: userId)
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
                  Get.off(
                        () => AirportPage(
                          tripid:  snapshot.data!.docs[index]['travelId'],
                          tripName: snapshot.data!.docs[index]['travleName'],
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
                                .collection(kMainCollections)
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
                child: Container(
decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                    border: Border.all(
                      color: kMainColor,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                    ]),
                  padding: const EdgeInsets.all(10
),
                  height: 200,
                  // width: 200,
                  margin: const EdgeInsets.symmetric(
                      vertical: 5, horizontal: 10),
                  child: Center(
                    child: Text(
                      snapshot.data!.docs[index]['travleName'],
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }


  void showCustomDialog(BuildContext context) {
    showDialog(

      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Directionality(textDirection: ui.TextDirection.rtl,
          child: Text("ادخال رقم الرحلة")),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Directionality(
                textDirection: ui.TextDirection.rtl,
                child: TextField(

                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "رقم الرحلة",
                  ),
                ),
              ),

            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("الغاء"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text("إضافة"),
              onPressed: () {
                if (nameController.text.isEmpty) {
                  // Show an alert or another error message if the field is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('يرجى تعبئة رقم الرحلة'),
                        duration: Duration(seconds: 2),
                      )
                  );
                } else {
                  submitData(); // Pass the data to be submitted
                  Navigator.of(context).pop(); // Close the dialog after data submission
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
      "time": Timestamp.now(),
    }).then((result) {
      print("Data added successfully.");
      nameController.clear();  // Clear the text fields after submission
      emailController.clear();
    }).catchError((error) {
      print("Failed to add data: $error");
    });
  }
}


