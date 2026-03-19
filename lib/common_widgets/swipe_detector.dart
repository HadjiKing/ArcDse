import 'package:fluent_ui/fluent_ui.dart';

/// Detects horizontal swipe gestures and calls the appropriate callback.
class SwipeDetector extends StatelessWidget {
  final Widget child;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;

  const SwipeDetector({
    super.key,
    required this.child,
    this.onSwipeLeft,
    this.onSwipeRight,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity == null) return;
        if (details.primaryVelocity! < -300) {
          onSwipeLeft?.call();
        } else if (details.primaryVelocity! > 300) {
          onSwipeRight?.call();
        }
      },
      child: child,
    );
  }
}
