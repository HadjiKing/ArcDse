import 'package:fluent_ui/fluent_ui.dart';

/// Workaround for a focus-related issue that can prevent Flyout menus from
/// receiving keyboard input on certain platforms.  Calling this before
/// showing a flyout transfers focus away from any currently focused text
/// field, which lets the flyout capture key events correctly.
Future<void> flyoutFocusFix(BuildContext context) async {
  final focusNode = FocusScope.of(context);
  if (focusNode.hasFocus) {
    focusNode.unfocus();
    await Future.delayed(const Duration(milliseconds: 50));
  }
}
