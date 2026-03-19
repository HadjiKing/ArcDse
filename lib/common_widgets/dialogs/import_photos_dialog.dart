import 'package:fluent_ui/fluent_ui.dart';

class ImportDialog extends StatelessWidget {
  final String panel;

  const ImportDialog({
    super.key,
    required this.panel,
  });

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text('Import Photos'),
      content: SizedBox(
        width: 400,
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Import photos for $panel'),
            const SizedBox(height: 16),
            
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    style: BorderStyle.dashed,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(FluentIcons.photo2, size: 48, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('Drop photos here or click to browse'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: Button(
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(FluentIcons.folder_open),
                        SizedBox(width: 8),
                        Text('Browse Files'),
                      ],
                    ),
                    onPressed: () {
                      // Open file picker for photos
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Button(
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(FluentIcons.camera),
                        SizedBox(width: 8),
                        Text('Take Photo'),
                      ],
                    ),
                    onPressed: () {
                      // Open camera
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        Button(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        FilledButton(
          child: const Text('Import'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}