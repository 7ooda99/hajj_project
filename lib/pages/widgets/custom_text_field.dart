import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syrian_hajj_project/core/constants.dart';

/// Converts Arabic-Indic digits (٠-٩) to Western digits (0-9).
class ArabicToEnglishDigitsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final converted = newValue.text
        .replaceAll('\u0660', '0').replaceAll('\u0661', '1')
        .replaceAll('\u0662', '2').replaceAll('\u0663', '3')
        .replaceAll('\u0664', '4').replaceAll('\u0665', '5')
        .replaceAll('\u0666', '6').replaceAll('\u0667', '7')
        .replaceAll('\u0668', '8').replaceAll('\u0669', '9')
        // Persian digits
        .replaceAll('\u06F0', '0').replaceAll('\u06F1', '1')
        .replaceAll('\u06F2', '2').replaceAll('\u06F3', '3')
        .replaceAll('\u06F4', '4').replaceAll('\u06F5', '5')
        .replaceAll('\u06F6', '6').replaceAll('\u06F7', '7')
        .replaceAll('\u06F8', '8').replaceAll('\u06F9', '9');
    return newValue.copyWith(
      text: converted,
      selection: newValue.selection,
    );
  }
}

/// Modern, card-style text field used in data-entry forms (باص / دينه).
class CustomTextField extends StatefulWidget {
  const CustomTextField({
    Key? key,
    this.inputType,
    this.suffexIcon,
    this.onSaved,
    this.onChange,
    this.maxLines,
    required this.lableText,
    this.controller,
    this.validator,
  }) : super(key: key);

  final String lableText;
  final TextInputType? inputType;
  final Widget? suffexIcon;
  final ValueSetter? onSaved;
  final ValueSetter? onChange;
  final int? maxLines;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: kSecondaryColor.withOpacity(0.18),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Focus(
            onFocusChange: (focused) => setState(() => _isFocused = focused),
            child: TextFormField(
              validator: widget.validator,
              controller: widget.controller,
              keyboardType: widget.inputType,
              onChanged: widget.onChange,
              onSaved: widget.onSaved,
              maxLines: widget.maxLines,
              inputFormatters: widget.inputType == TextInputType.number
                  ? [ArabicToEnglishDigitsFormatter(), FilteringTextInputFormatter.digitsOnly]
                  : null,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                color: Color(0xff2d2d2d),
              ),
              decoration: InputDecoration(
                labelText: widget.lableText,
                labelStyle: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w600,
                  color: _isFocused ? kSecondaryColor : const Color(0xff888888),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                filled: true,
                fillColor: _isFocused
                    ? Colors.white
                    : const Color(0xffF7F8FA),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xffE2E5EA),
                    width: 1.2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: kSecondaryColor.withOpacity(0.7),
                    width: 1.8,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xffE53E3E),
                    width: 1.2,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xffE53E3E),
                    width: 1.8,
                  ),
                ),
                errorStyle: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 11,
                  color: Color(0xffE53E3E),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Compact version used inside rows and dialogs.
class CustomSmallTextField extends StatefulWidget {
  const CustomSmallTextField({
    Key? key,
    this.inputType,
    this.suffexIcon,
    this.onSaved,
    this.onChange,
    this.maxLines,
    required this.lableText,
    this.controller,
  }) : super(key: key);

  final String lableText;
  final TextInputType? inputType;
  final Widget? suffexIcon;
  final ValueSetter? onSaved;
  final ValueSetter? onChange;
  final int? maxLines;
  final TextEditingController? controller;

  @override
  State<CustomSmallTextField> createState() => _CustomSmallTextFieldState();
}

class _CustomSmallTextFieldState extends State<CustomSmallTextField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: kSecondaryColor.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Focus(
            onFocusChange: (focused) => setState(() => _isFocused = focused),
            child: TextFormField(
              controller: widget.controller,
              keyboardType: widget.inputType,
              onChanged: widget.onChange,
              onSaved: widget.onSaved,
              maxLines: widget.maxLines,
              inputFormatters: widget.inputType == TextInputType.number
                  ? [ArabicToEnglishDigitsFormatter(), FilteringTextInputFormatter.digitsOnly]
                  : null,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                color: Color(0xff2d2d2d),
              ),
              decoration: InputDecoration(
                alignLabelWithHint: true,
                labelText: widget.lableText,
                labelStyle: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w600,
                  color: _isFocused ? kSecondaryColor : const Color(0xff888888),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                filled: true,
                fillColor: _isFocused
                    ? Colors.white
                    : const Color(0xffF7F8FA),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xffE2E5EA),
                    width: 1.2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: kSecondaryColor.withOpacity(0.7),
                    width: 1.8,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Styled text field for login & register screens — glass-style with icon.
class CustomSignTextField extends StatefulWidget {
  const CustomSignTextField({
    Key? key,
    this.inputType,
    this.prefixIcon,
    this.onSaved,
    this.onChange,
    this.maxLines,
    required this.lableText,
    this.suffixIcon,
    this.obscureText,
  }) : super(key: key);

  final String lableText;
  final TextInputType? inputType;
  final Widget? prefixIcon;
  final ValueSetter? onSaved;
  final ValueSetter? onChange;
  final int? maxLines;
  final Widget? suffixIcon;
  final bool? obscureText;

  @override
  State<CustomSignTextField> createState() => _CustomSignTextFieldState();
}

class _CustomSignTextFieldState extends State<CustomSignTextField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: _isFocused
              ? [
                  BoxShadow(
                    color: kSecondaryColor.withOpacity(0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Focus(
          onFocusChange: (focused) => setState(() => _isFocused = focused),
          child: TextFormField(
            obscureText: widget.obscureText ?? false,
            validator: (data) {
              if (data!.isEmpty) {
                return 'يجب ادخال قيمة';
              }
              return null;
            },
            keyboardType: widget.inputType,
            onChanged: widget.onChange,
            onSaved: widget.onSaved,
            maxLines: widget.maxLines,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 15,
              color: Color(0xff2d2d2d),
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              prefixIcon: widget.prefixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: IconTheme(
                        data: IconThemeData(
                          color: _isFocused
                              ? kSecondaryColor
                              : const Color(0xff999999),
                          size: 20,
                        ),
                        child: widget.prefixIcon!,
                      ),
                    )
                  : null,
              suffixIcon: widget.suffixIcon,
              labelText: widget.lableText,
              labelStyle: TextStyle(
                fontSize: 14,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w600,
                color: _isFocused ? kSecondaryColor : const Color(0xff888888),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              filled: true,
              fillColor: _isFocused
                  ? Colors.white
                  : Colors.white.withOpacity(0.85),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(
                  color: Colors.white.withOpacity(0.6),
                  width: 1.2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(
                  color: kSecondaryColor.withOpacity(0.7),
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(
                  color: Color(0xffE53E3E),
                  width: 1.2,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(
                  color: Color(0xffE53E3E),
                  width: 2,
                ),
              ),
              errorStyle: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 11,
                color: Color(0xffE53E3E),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
