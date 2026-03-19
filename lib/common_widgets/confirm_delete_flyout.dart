import 'package:fluent_ui/fluent_ui.dart';

class ConfirmDeleteFlyout extends StatelessWidget {
  final String itemName;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmDeleteFlyout({
    super.key,
    required this.itemName,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return FlyoutContent(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Confirm Delete',
            style: FluentTheme.of(context).typography.bodyStrong,
          ),
          const SizedBox(height: 8),
          Text(
            'Are you sure you want to delete "$itemName"?',
            style: FluentTheme.of(context).typography.body,
          ),
          Text(
            'This action cannot be undone.',
            style: FluentTheme.of(context).typography.caption?.copyWith(
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Button(
                child: const Text('Cancel'),
                onPressed: onCancel,
              ),
              const SizedBox(width: 8),
              FilledButton(
                style: ButtonStyle(
                  backgroundColor: ButtonState.all(Colors.red),
                ),
                onPressed: onConfirm,
                child: const Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}