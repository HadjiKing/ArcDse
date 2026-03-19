import 'package:arcdse/services/localization/locale.dart';
import 'package:arcdse/services/backups.dart';
import 'package:arcdse/utils/logger.dart';
import 'package:fluent_ui/fluent_ui.dart';

/// Settings pane that lists PocketBase backups and lets admins manage them.
class BackupsSettings extends StatefulWidget {
  const BackupsSettings({super.key});

  @override
  State<BackupsSettings> createState() => _BackupsSettingsState();
}

class _BackupsSettingsState extends State<BackupsSettings> {
  @override
  void initState() {
    super.initState();
    backups.reloadFromRemote().then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: backups.list.stream,
      builder: (context, _) {
        if (backups.loading()) {
          return const Center(child: ProgressRing());
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FilledButton(
                  onPressed: backups.creating()
                      ? null
                      : () async {
                          await backups.newBackup();
                          if (mounted) setState(() {});
                        },
                  child: backups.creating()
                      ? const ProgressRing()
                      : Text(txt("createBackup")),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: backups.uploading()
                      ? null
                      : () async {
                          await backups.pickAndUpload();
                          if (mounted) setState(() {});
                        },
                  child: backups.uploading()
                      ? const ProgressRing()
                      : Text(txt("uploadBackup")),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...backups.list().map((b) {
              return ListTile(
                title: Text(b.key),
                subtitle: Text(b.date.toLocal().toString()),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(FluentIcons.download),
                      onPressed: backups.downloading()[b.key] == true
                          ? null
                          : () async {
                              try {
                                final uri = await backups.downloadUri(b.key);
                                if (mounted) setState(() {});
                              } catch (e, s) {
                                logger('Backup download error: $e', s);
                              }
                            },
                    ),
                    IconButton(
                      icon: const Icon(FluentIcons.remove),
                      onPressed: backups.deleting()[b.key] == true
                          ? null
                          : () async {
                              await backups.delete(b.key);
                              if (mounted) setState(() {});
                            },
                    ),
                    FilledButton(
                      style: const ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(Colors.warningPrimaryColor),
                      ),
                      onPressed: backups.restoring()[b.key] == true
                          ? null
                          : () async {
                              await backups.restore(b.key);
                            },
                      child: Text(txt("restore")),
                    ),
                  ],
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
