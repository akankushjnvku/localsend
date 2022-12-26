import 'package:flutter/material.dart';

class RotatingWidget extends StatefulWidget {
  final Duration duration;
  final bool spinning;
  final bool reverse;
  final Widget child;

  const RotatingWidget({required this.duration, this.spinning = true, this.reverse = false, required this.child, super.key});

  @override
  State<RotatingWidget> createState() => RotatingWidgetState();
}

class RotatingWidgetState extends State<RotatingWidget> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: widget.duration,
    vsync: this,
  );

  late final Animation<double> _animation = widget.reverse
      ? ReverseAnimation(CurvedAnimation(
          parent: _controller,
          curve: Curves.linear.flipped,
        ))
      : CurvedAnimation(
          parent: _controller,
          curve: Curves.linear.flipped,
        );

  @override
  void initState() {
    super.initState();
    if (widget.spinning) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(RotatingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.spinning && !widget.spinning) {
      _controller.stop();
    } else if (!oldWidget.spinning && widget.spinning) {
      _controller.repeat();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _animation,
      child: widget.child,
    );
  }
}