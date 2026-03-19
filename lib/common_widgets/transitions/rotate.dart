import 'package:fluent_ui/fluent_ui.dart';

class RotateTransition extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final bool animate;

  const RotateTransition({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.animate = true,
  });

  @override
  State<RotateTransition> createState() => _RotateTransitionState();
}

class _RotateTransitionState extends State<RotateTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.animate) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(RotateTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !oldWidget.animate) {
      _controller.forward();
    } else if (!widget.animate && oldWidget.animate) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _animation.value * 2 * 3.14159, // Full rotation
          child: widget.child,
        );
      },
    );
  }
}