import 'package:flutter/material.dart';




class CustomButton extends StatelessWidget {
  const CustomButton({Key? key, this.text, this.onTap, this.color})
      : super(key: key);

  final String? text;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13),
        child: Container(
          height: 60,
       
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(25)),
          child: Center(
            child: Text(
              text!,
              style: const TextStyle(
                  color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold,fontFamily: 'Cairo'),
            ),
          ),
        ),
      ),
    );
  }
}
