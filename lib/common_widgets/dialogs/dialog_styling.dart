import 'package:fluent_ui/fluent_ui.dart';

/// Returns a [ContentDialogThemeData] configured for the current [context].
/// [wide] requests extra horizontal padding when true.
ContentDialogThemeData dialogStyling(BuildContext context, bool wide) {
  return ContentDialogThemeData(
    padding: wide
        ? const EdgeInsets.symmetric(horizontal: 32, vertical: 24)
        : const EdgeInsets.all(16),
    titleStyle: FluentTheme.of(context).typography.subtitle,
    bodyStyle: FluentTheme.of(context).typography.body,
  );
}
