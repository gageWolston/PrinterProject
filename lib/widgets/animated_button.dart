import 'package:flutter/material.dart';

class AnimatedActionButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final ButtonStyle? style;

  const AnimatedActionButton({
    required this.onPressed,
    required this.child,
    this.style,
    super.key,
  });

  @override
  State<AnimatedActionButton> createState() => _AnimatedActionButtonState();
}

class _AnimatedActionButtonState extends State<AnimatedActionButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (widget.onPressed == null) return;

    if (_pressed != value) {
      setState(() => _pressed = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _setPressed(true),
      onPointerUp: (_) => _setPressed(false),
      onPointerCancel: (_) => _setPressed(false),
      child: AnimatedScale(
        scale: _pressed && widget.onPressed != null ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: ElevatedButton(
          style: widget.style,
          onPressed: widget.onPressed,
          child: widget.child,
        ),
      ),
    );
  }
}
