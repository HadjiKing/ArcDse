import 'package:fluent_ui/fluent_ui.dart';

/// A base [ButtonStyle] for [FilledButton]s used throughout the app.
/// Consumers can call [ButtonStyle.copyWith] to adjust individual properties.
final ButtonStyle greyButtonStyle = ButtonStyle(
  backgroundColor: const WidgetStatePropertyAll(Colors.grey),
  padding: const WidgetStatePropertyAll(
    EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  ),
);

/// A convenience widget that lays out an icon followed by a label.
class ButtonContent extends StatelessWidget {
  final IconData icon;
  final String label;

  const ButtonContent(this.icon, this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}
