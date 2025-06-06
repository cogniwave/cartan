import 'package:flutter/material.dart';

class CustomTap extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Duration fadeDuration;
  final double pressedOpacity;

  const CustomTap({
    super.key,
    required this.child,
    this.onTap,
    this.fadeDuration = const Duration(milliseconds: 100),
    this.pressedOpacity = 0.6,
  });

  @override
  State<CustomTap> createState() => _CustomTapState();
}

class _CustomTapState extends State<CustomTap> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails _) {
    setState(() => _isPressed = true);
  }

  Future<void> _handleTapUp(TapUpDetails _) async {
    await Future.delayed(widget.fadeDuration);
    widget.onTap?.call();
    if (mounted) {
      setState(() => _isPressed = false);
    }
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedOpacity(
        duration: widget.fadeDuration,
        opacity: _isPressed ? widget.pressedOpacity : 1.0,
        child: widget.child,
      ),
    );
  }
}