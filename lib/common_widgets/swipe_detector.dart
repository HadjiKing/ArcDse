import 'package:fluent_ui/fluent_ui.dart';

class SwipeDetector extends StatefulWidget {
  final Widget child;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final VoidCallback? onSwipeUp;
  final VoidCallback? onSwipeDown;

  const SwipeDetector({
    super.key,
    required this.child,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.onSwipeUp,
    this.onSwipeDown,
  });

  @override
  State<SwipeDetector> createState() => _SwipeDetectorState();
}

class _SwipeDetectorState extends State<SwipeDetector> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanEnd: (DragEndDetails details) {
        final velocity = details.velocity.pixelsPerSecond;
        
        if (velocity.dx.abs() > velocity.dy.abs()) {
          // Horizontal swipe
          if (velocity.dx > 0) {
            widget.onSwipeRight?.call();
          } else {
            widget.onSwipeLeft?.call();
          }
        } else {
          // Vertical swipe
          if (velocity.dy > 0) {
            widget.onSwipeDown?.call();
          } else {
            widget.onSwipeUp?.call();
          }
        }
      },
      child: widget.child,
    );
  }
}