import 'package:flutter/material.dart';
import 'package:syrian_hajj_project/core/constants.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({Key? key, this.text, this.onTap, this.color})
      : super(key: key);

  final String? text;
  final Color? color;
  final VoidCallback? onTap;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.color ?? kSecondaryColor;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  bgColor,
                  Color.lerp(bgColor, Colors.black, 0.15)!,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: bgColor.withOpacity(0.35),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                widget.text ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

