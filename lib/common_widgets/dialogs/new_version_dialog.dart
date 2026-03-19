import 'package:fluent_ui/fluent_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class NewVersionDialog extends StatelessWidget {
  final String downloadLink;

  const NewVersionDialog({
    super.key,
    required this.downloadLink,
  });

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text('New Version Available'),
      content: const SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'A new version of ArcDSE is available!',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'We recommend updating to the latest version to get the newest features and bug fixes.',
            ),
            SizedBox(height: 16),
            Text(
              'Features in this update:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('• Improved performance'),
            Text('• Bug fixes and stability improvements'),
            Text('• Enhanced user interface'),
            Text('• New reporting features'),
            SizedBox(height: 16),
            Text(
              'Click "Download" to get the latest version.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
      actions: [
        Button(
          child: const Text('Later'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        FilledButton(
          child: const Text('Download'),
          onPressed: () async {
            final uri = Uri.parse(downloadLink);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
            }
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}