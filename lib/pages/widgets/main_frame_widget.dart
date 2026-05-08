import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../core/size_config.dart';

class MainFameWidget extends StatelessWidget {
  const MainFameWidget({
    Key? key,
    required this.text,
    required this.icon,
    this.color = Colors.black,
    this.onTap,
  }) : super(key: key);

  final VoidCallback? onTap;
  final String text;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.4)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Cairo',
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
