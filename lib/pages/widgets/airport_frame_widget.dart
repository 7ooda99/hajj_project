import 'package:flutter/material.dart';
import 'package:syrian_hajj_project/core/constants.dart';
import 'package:syrian_hajj_project/core/size_config.dart';
import 'package:syrian_hajj_project/pages/widgets/custom_text_info_widget.dart';
import 'package:syrian_hajj_project/pages/widgets/tima_date_widget.dart';

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
  }) : super(key: key);
  final String? hotelName;
  final String? group;
  final String? passengerNo;
  final String? gpsNo;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final String? time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 1),
      child: Material(
        shadowColor: Colors.grey,
        elevation: 10,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: GestureDetector(
          onLongPress: onLongPress,
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: kMainColor,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            height: SizeConfig.defaultSize! * 22,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
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
                          title: 'GPS',
                          subTitle: gpsNo,
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomTextInfoWidget(
                          title: 'الحملة',
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
                SizedBox(
                  height: SizeConfig.defaultSize! * 2,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TimeWidget(
                        time: time,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
