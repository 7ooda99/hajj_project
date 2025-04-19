import 'package:flutter/material.dart';
import 'package:syrian_hajj_project/core/constants.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {Key? key,
      @required this.inputType,
      this.suffexIcon,
      @required this.onSaved,
      this.onChange,
      this.maxLines,
      required this.lableText,
      this.controller, this.validator})
      : super(key: key);
  final String lableText;
  final TextInputType? inputType;
  final Widget? suffexIcon;
  final ValueSetter? onSaved;
  final ValueSetter? onChange;
  final int? maxLines;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: TextFormField(
          validator: validator,
          // (value) {
          //   if (value == null || value.isEmpty) {
          //     return 'الرجاء ادخال بيانات';
          //   }
          //   return null;
          // }
          // ,
          controller: controller,
          keyboardType: inputType,
          onChanged: onChange,
          onSaved: onSaved,
          maxLines: maxLines,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: const BorderSide(color: Colors.black),
            ),
            labelText: lableText,
            labelStyle: const TextStyle(
                fontSize: 14, color: Colors.black, fontFamily: 'Cairo'),
            filled: true,
            fillColor: Colors.transparent,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xffcccccc)),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomSmallTextField extends StatelessWidget {
  const CustomSmallTextField(
      {Key? key,
      @required this.inputType,
      this.suffexIcon,
      @required this.onSaved,
      this.onChange,
      this.maxLines,
      required this.lableText,
      this.controller})
      : super(key: key);
  final String lableText;
  final TextInputType? inputType;
  final Widget? suffexIcon;
  final ValueSetter? onSaved;
  final ValueSetter? onChange;
  final int? maxLines;
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'الرجاء ادخال بيانات';
            }
            return null;
          },
          controller: controller,
          keyboardType: inputType,
          onChanged: onChange,
          onSaved: onSaved,
          maxLines: maxLines,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: const BorderSide(color: Colors.black),
            ),
            alignLabelWithHint: true,
            labelText: lableText,
            labelStyle: const TextStyle(
                fontSize: 14, color: Colors.black, fontFamily: 'Cairo'),
            filled: true,
            fillColor: Colors.transparent,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xffcccccc)),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomSignTextField extends StatelessWidget {
  const CustomSignTextField(
      {Key? key,
      @required this.inputType,
      this.prefixIcon,
      @required this.onSaved,
      this.onChange,
      this.maxLines,
      required this.lableText,
      this.suffixIcon,
      @required this.obscureText})
      : super(key: key);
  final String lableText;
  final TextInputType? inputType;
  final Widget? prefixIcon;
  final ValueSetter? onSaved;
  final ValueSetter? onChange;
  final int? maxLines;
  final Widget? suffixIcon;
  final bool? obscureText;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        obscureText: obscureText!,
        validator: (data) {
          if (data!.isEmpty) {
            return 'يجب ادخال قيمة';
          }
          return null;
        },
        keyboardType: inputType,
        onChanged: onChange,
        onSaved: onSaved,
        maxLines: maxLines,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: const BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: const BorderSide(color: Colors.black),
          ),
          labelText: lableText,
          labelStyle:
              const TextStyle(fontSize: 16, color: Colors.black, fontFamily: 'Cairo'),
          filled: true,
          fillColor: kMainColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }
}
