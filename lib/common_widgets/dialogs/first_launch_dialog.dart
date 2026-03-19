import 'package:arcdse/services/localization/locale.dart';
import 'package:fluent_ui/fluent_ui.dart';

/// Dialog shown on the very first launch of the application.
class FirstLaunchDialog extends StatelessWidget {
  const FirstLaunchDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Text(txt("welcome")),
      content: Text(txt("firstLaunchMessage")),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(txt("continue")),
        ),
      ],
    );
  }
}
