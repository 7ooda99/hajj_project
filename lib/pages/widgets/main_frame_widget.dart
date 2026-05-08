import 'package:flutter/material.dart';

import '../../core/constants.dart';

class MainFameWidget extends StatefulWidget {
  const MainFameWidget({
    Key? key,
    required this.text,
    required this.icon,
    this.color = kSecondaryColor,
    this.onTap,
  }) : super(key: key);

  final VoidCallback? onTap;
  final String text;
  final IconData icon;
  final Color color;

  @override
  State<MainFameWidget> createState() => _MainFameWidgetState();
}

class _MainFameWidgetState extends State<MainFameWidget>
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
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
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.color.withOpacity(0.12),
                widget.color.withOpacity(0.04),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.color.withOpacity(0.25),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.12),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(widget.icon, size: 26, color: widget.color),
              ),
              const SizedBox(width: 14),
              Text(
                widget.text,
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  color: widget.color,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
