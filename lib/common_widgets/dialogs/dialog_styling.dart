import 'package:fluent_ui/fluent_ui.dart';

ContentDialogThemeData dialogStyling(BuildContext context, bool fullScreen) {
  final theme = FluentTheme.of(context);
  
  return ContentDialogThemeData(
    decoration: BoxDecoration(
      color: theme.scaffoldBackgroundColor,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 20,
          spreadRadius: 2,
        ),
      ],
    ),
    titleStyle: theme.typography.subtitle,
    contentStyle: theme.typography.body,
    actionsDecoration: BoxDecoration(
      border: Border(
        top: BorderSide(
          color: theme.resources.dividerStrokeColorDefault,
          width: 1,
        ),
      ),
    ),
  );
}