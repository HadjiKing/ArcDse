import 'package:fluent_ui/fluent_ui.dart';

/// A small close/dismiss button intended to sit in the corner of a dialog.
class CloseButtonInDialog extends StatelessWidget {
  const CloseButtonInDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(FluentIcons.cancel),
      onPressed: () => Navigator.of(context).pop(),
    );
  }
}
