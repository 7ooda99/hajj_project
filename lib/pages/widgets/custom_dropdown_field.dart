import 'package:flutter/material.dart';
import 'package:syrian_hajj_project/core/constants.dart';

/// A modern, consistent dropdown field that matches the new [CustomTextField] styling.
class CustomDropdownField<T> extends StatefulWidget {
  const CustomDropdownField({
    Key? key,
    required this.labelText,
    required this.items,
    this.value,
    this.onChanged,
    this.onSaved,
    this.validator,
  }) : super(key: key);

  final String labelText;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final FormFieldSetter<T>? onSaved;
  final String? Function(T?)? validator;

  @override
  State<CustomDropdownField<T>> createState() => _CustomDropdownFieldState<T>();
}

class _CustomDropdownFieldState<T> extends State<CustomDropdownField<T>> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
            child: DropdownButtonFormField<T>(
              // Only pass value if it exists in items to avoid assertion error
              value: widget.value != null &&
                      widget.items.any((item) => item.value == widget.value)
                  ? widget.value
                  : null,
              style: const TextStyle(
                color: Color(0xff2d2d2d),
                fontSize: 14,
                fontFamily: 'Cairo',
              ),
              borderRadius: BorderRadius.circular(14),
              alignment: Alignment.bottomRight,
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: _isFocused ? kSecondaryColor : const Color(0xff999999),
              ),
              decoration: InputDecoration(
                labelText: widget.labelText,
                labelStyle: TextStyle(
                  color: _isFocused ? kSecondaryColor : const Color(0xff888888),
                  fontSize: 13,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w600,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                filled: true,
                fillColor: _isFocused ? Colors.white : const Color(0xffF7F8FA),
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
              items: widget.items,
              onChanged: widget.onChanged,
              onSaved: widget.onSaved,
              validator: widget.validator,
            ),
          ),
        ),
      ),
    );
  }
}
