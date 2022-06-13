import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../core/size_config.dart';

class MainFameWidget extends StatelessWidget {
  const MainFameWidget({
    Key? key,
    required this.text,
    required this.icon,
    this.color,
    this.onTap,
  }) : super(key: key);
  final VoidCallback? onTap;
  final String? text;
  final Icon? icon;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        left: 1,
        right: 1,
      ),
      child: Material(
        shadowColor: Colors.grey,
        elevation: 5,
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: kSecondaryColor,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            height: SizeConfig.defaultSize! * 15,
            width: SizeConfig.defaultSize! * 18.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon!,
                Text(
                  text!,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Cairo',
                    color: color,
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
