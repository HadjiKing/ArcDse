import 'package:fluent_ui/fluent_ui.dart';
import 'network_actions_controller.dart';

class NetworkActions extends StatelessWidget {
  const NetworkActions({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: networkActions.isSyncing.stream,
      builder: (context, snapshot) {
        final syncCount = snapshot.data ?? 0;
        final isSyncing = syncCount > 0;
        
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Sync indicator
            if (isSyncing) ...[
              const SizedBox(
                width: 16,
                height: 16,
                child: ProgressRing(strokeWidth: 2),
              ),
              const SizedBox(width: 8),
              Text('Syncing ($syncCount)'),
            ] else
              const Icon(FluentIcons.cloud_check, color: Colors.green),
            
            const SizedBox(width: 16),
            
            // Manual sync button
            IconButton(
              icon: const Icon(FluentIcons.sync),
              onPressed: isSyncing ? null : networkActions.resync,
            ),
          ],
        );
      },
    );
  }
}