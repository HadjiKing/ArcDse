import 'package:arcdse/features/network_actions/network_actions_controller.dart';
import 'package:arcdse/services/localization/locale.dart';
import 'package:arcdse/services/network.dart';
import 'package:fluent_ui/fluent_ui.dart';

/// Displays the current network/sync status in the app bar.
class NetworkActions extends StatelessWidget {
  const NetworkActions({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: networkActions.isSyncing.stream,
      builder: (context, _) {
        final syncing = networkActions.isSyncing() > 0;
        return StreamBuilder(
          stream: network.isOnline.stream,
          builder: (context, _) {
            final online = network.isOnline();
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (syncing)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: ProgressRing(strokeWidth: 2),
                    ),
                  ),
                Tooltip(
                  message: online ? txt("online") : txt("offline"),
                  child: Icon(
                    online ? FluentIcons.cloud : FluentIcons.cloud_offline,
                    color:
                        online ? Colors.successPrimaryColor : Colors.grey,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
