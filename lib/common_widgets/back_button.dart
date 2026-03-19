import 'package:fluent_ui/fluent_ui.dart';
import '../widget_keys.dart';

class BackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const BackButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: WK.backButton,
      icon: const Icon(FluentIcons.back),
      onPressed: onPressed ?? () {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      },
    );
  }
}