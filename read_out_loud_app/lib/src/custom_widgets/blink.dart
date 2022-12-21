import 'package:flutter/material.dart';

class Blink extends StatefulWidget {
  const Blink({
    required this.child,
    Key? key,
    this.blinkDuration = Duration.zero,
  }) : super(key: key);
  final Duration blinkDuration;
  final Widget child;

  @override
  State<StatefulWidget> createState() => _BlinkerState();
}

class _BlinkerState extends State<Blink> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  @override
  void initState() {
    if (widget.blinkDuration != Duration.zero) {
      _animationController =
          AnimationController(vsync: this, duration: widget.blinkDuration);
      _animationController.repeat(reverse: true);
    }

    super.initState();
  }

  @override
  void dispose() {
    if (widget.blinkDuration != Duration.zero) {
      _animationController.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.blinkDuration == Duration.zero) {
      return widget.child;
    }

    return FadeTransition(
      opacity: _animationController,
      child: widget.child,
    );
  }
}
