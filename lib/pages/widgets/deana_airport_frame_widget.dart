import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syrian_hajj_project/core/constants.dart';
import 'package:syrian_hajj_project/core/size_config.dart';
import 'package:syrian_hajj_project/pages/widgets/custom_text_info_widget.dart';
import 'package:syrian_hajj_project/pages/widgets/tima_date_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../../helper/show_snack_bar.dart';




class DeanaAirportFrameWidget extends StatelessWidget {
  const DeanaAirportFrameWidget({
    Key? key,
    this.hotelName,
    this.group,
    this.passengerNo,
    this.gpsNo,
    this.onTap,
    this.onLongPress,
    this.time, required this.index, required this.tripName,required this.travelId, this.userRole,
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
  @override
  Widget build(BuildContext context) {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 1),
      child: Material(
        shadowColor: Colors.grey,
        elevation: 1,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: GestureDetector(
          onLongPress: onLongPress,
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border(
                left: BorderSide(color: kMainColor, width: 4),
              ),
            ),
            height: SizeConfig.defaultSize! * 13,
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
                            userId!,
                            index,
                            tripName,
                            travelId,
                            userRole!,
                          );
                        },
                        icon: const Icon(Icons.share, size: 20,)),
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
                                // CustomTextInfoWidget(
                                //   title: 'الفندق',
                                //   subTitle: hotelName,
                                // ),
                                CustomTextInfoWidget(
                                  title: 'عدد الحقائب',
                                  subTitle: gpsNo,
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // CustomTextInfoWidget(
                                //   title: 'اسم المجموعة',
                                //   subTitle: group,
                                // ),
                                CustomTextInfoWidget(
                                  title: 'اسم المجموعة',
                                  subTitle: passengerNo,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(
                          flex: 1,
                        ),
                        const Divider(thickness: 0.5, height: 16, endIndent: 10,indent: 10,),

                        // SizedBox(
                        //   height: SizeConfig.defaultSize! * 1,
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 0),
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
                        )
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future<String> fetchTravelIds(String userId, int userTripIndex, String tripName, String travelId, String userRole) async {
    print('Fetching for userId at trip index: $userTripIndex');

    // Fetch user trips
    var snapshot =
    userRole != 'admin' ?
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

    if (userTripIndex >= snapshot.docs.length) {
      print('Invalid trip index: $userTripIndex');
      return '';
    }

    // var selectedTripData = snapshot.docs[userTripIndex].data();
    // var travelId = selectedTripData['travelId'] as String;
    // print('Selected travelId: $travelId');

    // Fetch all دينه under selected trip
    var querySnapshot = await FirebaseFirestore.instance
        .collection(kMessagesCollections)
        .where('travelId', isEqualTo: travelId)
        .where('type', isEqualTo: 'دينه')
        .orderBy('time', descending: true)
        .get();

    if (querySnapshot.docs.isEmpty) {
      print('No دينه found for travelId: $travelId');
      // showSnackBar(Get.context!, 'لا توجد بيانات لمشاركتها');
      return '';
    }

    // Always pick the first دينه (or you can later pass a specific index for دينه selection)
    var clickedDocData = querySnapshot.docs[index].data();
    String formattedDate = DateFormat('yyyy/MM/dd').format(
      (clickedDocData['time'] as Timestamp).toDate(),
    );
    String formattedData = '''
🚚 بيانات دينه :- 
الرحلة: $tripName
تاريخ : $formattedDate
اسم السائق: ${clickedDocData['group'] ?? ''}
جوال السائق: ${clickedDocData['hotel'] ?? ''}
رقم الدينه: ${clickedDocData['busNumber'] ?? ''}
اسم الفندق: ${clickedDocData['gps'] ?? ''}
اسم المجموعة: ${clickedDocData['groupName'] ?? ''}
عدد الحقائب: ${clickedDocData['totalBags'] ?? ''}
ملاحظات: ${clickedDocData['notes'] ?? ''}
-------------------------------------------------
''';

    print('Selected Document data:\n$formattedData');

    Share.share(
      formattedData,
      subject: 'تفاصيل الرحلة ',
    );

    return travelId;
  }}
