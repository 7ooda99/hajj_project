import 'package:flutter/material.dart';
import 'package:syrian_hajj_project/core/constants.dart';


class CustomTextInfoWidget extends StatelessWidget {
  const CustomTextInfoWidget({Key? key, this.title, this.subTitle})
      : super(key: key);
  final String? title;
  final dynamic subTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          ': $title',
          style:  TextStyle(
            fontFamily: 'Cairo',
            color: Colors.grey[800],
            fontSize: 20,
          ),
        ),
        Text(
          '$subTitle',
          style: const TextStyle(
            color: kSecondaryColor,
            fontSize: 16,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }
}
