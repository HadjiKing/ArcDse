import 'package:fluent_ui/fluent_ui.dart';

/// Animates its [child] from 0 to [turns] * 360° when [animate] is true.
class RotateTransitionWidget extends StatefulWidget {
  final Widget child;
  final bool animate;
  final double turns;

  const RotateTransitionWidget({
    super.key,
    required this.child,
    this.animate = false,
    this.turns = 1,
  });

  @override
  State<RotateTransitionWidget> createState() =>
      _RotateTransitionWidgetState();
}

class _RotateTransitionWidgetState extends State<RotateTransitionWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = Tween(begin: 0.0, end: widget.turns).animate(_ctrl);
    if (widget.animate) _ctrl.forward();
  }

  @override
  void didUpdateWidget(RotateTransitionWidget old) {
    super.didUpdateWidget(old);
    if (widget.animate != old.animate) {
      widget.animate ? _ctrl.forward() : _ctrl.reverse();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      RotationTransition(turns: _animation, child: widget.child);
}
