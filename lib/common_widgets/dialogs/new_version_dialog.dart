import 'package:arcdse/services/localization/locale.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:url_launcher/url_launcher.dart';

/// Dialog shown when a newer version of the application is available.
class NewVersionDialog extends StatelessWidget {
  final String? downloadLink;
  const NewVersionDialog({super.key, this.downloadLink});

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Text(txt("newVersionAvailable")),
      content: Text(txt("newVersionMessage")),
      actions: [
        if (downloadLink != null && downloadLink!.isNotEmpty)
          FilledButton(
            onPressed: () async {
              final uri = Uri.tryParse(downloadLink!);
              if (uri != null) await launchUrl(uri);
              if (context.mounted) Navigator.of(context).pop();
            },
            child: Text(txt("download")),
          ),
        Button(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(txt("close")),
        ),
      ],
    );
  }
}
