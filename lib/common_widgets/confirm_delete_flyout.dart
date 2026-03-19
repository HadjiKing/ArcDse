import 'package:arcdse/services/localization/locale.dart';
import 'package:fluent_ui/fluent_ui.dart';

/// A flyout that asks the user to confirm a destructive delete action.
class ConfirmDeleteFlyout extends StatelessWidget {
  final VoidCallback onConfirm;
  const ConfirmDeleteFlyout({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return FlyoutContent(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            txt("confirmDelete"),
            style: FluentTheme.of(context).typography.bodyStrong,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              FilledButton(
                style: const ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(Colors.errorPrimaryColor)),
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm();
                },
                child: Text(txt("delete")),
              ),
              const SizedBox(width: 8),
              Button(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(txt("cancel")),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
