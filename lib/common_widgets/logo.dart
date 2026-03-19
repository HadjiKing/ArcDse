import 'package:fluent_ui/fluent_ui.dart';

/// The application logo displayed in the navigation pane header.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Center(
        child: Text(
          'ArcDse',
          style: FluentTheme.of(context)
              .typography
              .title!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
