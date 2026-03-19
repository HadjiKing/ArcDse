import 'package:fluent_ui/fluent_ui.dart';

class CloseDialogButton extends StatelessWidget {
  const CloseDialogButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Button(
      child: const Text('Close'),
      onPressed: () => Navigator.of(context).pop(),
    );
  }
}