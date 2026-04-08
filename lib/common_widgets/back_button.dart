import 'package:arcdse/app/routes.dart';
import 'package:fluent_ui/fluent_ui.dart';

/// A back button that navigates to the previous route.
class BackButton extends StatelessWidget {
  const BackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(FluentIcons.back),
      onPressed: routes.goBack,
    );
  }
}
