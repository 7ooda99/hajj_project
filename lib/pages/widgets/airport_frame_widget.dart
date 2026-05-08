import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syrian_hajj_project/core/constants.dart';
import 'package:syrian_hajj_project/core/size_config.dart';
import 'package:syrian_hajj_project/pages/widgets/custom_text_info_widget.dart';
import 'package:syrian_hajj_project/pages/widgets/tima_date_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:get/get.dart';
import '../../helper/show_snack_bar.dart';
import 'package:intl/intl.dart';
class AirportFrameWidget extends StatelessWidget {
  const AirportFrameWidget({
    Key? key,
    this.hotelName,
    this.group,
    this.passengerNo,
    this.gpsNo,
    this.onTap,
    this.onLongPress,
    this.time,
    required this.index,
    required this.tripName,
    required this.travelId,
    this.userRole, this.isSent,
  }) : super(key: key);
  final String? hotelName;
  final String? group;
  final String? passengerNo;
  final String? gpsNo;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final String? time;
  final int index;
  final String tripName;
  final String travelId;
  final String? userRole;
  final bool? isSent ;

  @override
  Widget build(BuildContext context) {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 1),
      child: Material(
        shadowColor: Colors.grey,
        elevation: 1,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        child: GestureDetector(
          onLongPress: onLongPress,
          onTap: onTap,
          child: Container(
              decoration: BoxDecoration(
                color: (isSent != true) ? Colors.white : Colors.green[100],
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border(
                  left: BorderSide(color: (isSent != true) ?  kMainColor : Colors.black, width: 4),
                ),
              ),
            height: SizeConfig.defaultSize! * 18,
            // width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0),
              child: Stack(
                // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Positioned(
                    // alignment: AlignmentDirectional.bottomEnd,
                    bottom: 0,
                    left: 0,
                    child: IconButton(
                        onPressed: () {
                          fetchTravelIds(
                              userId!, index, tripName, travelId, userRole!, gpsNo!);
                        },
                        icon: const Icon(
                          Icons.share,
                          size: 20,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomTextInfoWidget(
                                  title: 'الفندق',
                                  subTitle: hotelName,
                                ),
                                CustomTextInfoWidget(
                                  title: 'رقم الباص',
                                  subTitle: gpsNo,
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomTextInfoWidget(
                                  title: 'اسم المجموعة',
                                  subTitle: group,
                                ),
                                CustomTextInfoWidget(
                                  title: 'الحجاج',
                                  subTitle: passengerNo,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Spacer(
                          flex: 1,
                        ),
                        const Divider(thickness: 0.5, height: 16, endIndent: 10,indent: 10,),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              TimeWidget(
                                time: time,
                              ),
                              const SizedBox(width: 5),

                              Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(
                  //   height: SizeConfig.defaultSize! * 14,
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String> fetchTravelIds(String userId, int index, String tripName,
      String travelId, String userRole, String busNumber) async {

    print('Fetching for travelId: $travelId and busNumber: $busNumber');

    // Fetch the specific document matching travelId and busNumber (unique identifier)
    var querySnapshot = await FirebaseFirestore.instance
        .collection(kMessagesCollections)
        .where('travelId', isEqualTo: travelId)
        .where('busNumber', isEqualTo: busNumber) // uniquely identifying the document
        .limit(1) // expecting exactly one document
        .get();

    if (querySnapshot.docs.isEmpty) {
      print('No document found for travelId: $travelId with busNumber: $busNumber');
      showSnackBar(Get.context!, 'لا توجد بيانات لمشاركتها');
      return '';
    }

    // Clearly fetch the single matching document
    var clickedDocData = querySnapshot.docs.first.data();
    String formattedDate = DateFormat('yyyy/MM/dd').format(
      (clickedDocData['time'] as Timestamp).toDate(),
    );
    String formattedData = '''
🚌 بيانات الباصات للرحلة : $tripName
تاريخ : $formattedDate
اسم السائق : ${clickedDocData['group'] ?? ''}
هاتف السائق : ${clickedDocData['hotel'] ?? ''}
رقم الباص : ${clickedDocData['busNumber'] ?? ''}
الشركة الناقلة : ${clickedDocData['transfareCompany'] ?? ''}
الفندق : ${clickedDocData['gps'] ?? ''}
اسم المجموعة / التكتل : ${clickedDocData['groupName'] ?? ''}
عدد الحجاج : ${clickedDocData['passenger'] ?? ''}
الملاحظات : ${clickedDocData['notes'] ?? ''}
--------------------
''';

    print('Selected Document data:\n$formattedData');

    Share.share(
      formattedData,
      subject: 'تفاصيل الرحلة',
    );

    return travelId;
  }
}
