import 'package:fluent_ui/fluent_ui.dart';

class BackupsSettings extends StatelessWidget {
  const BackupsSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Backup Management',
          style: FluentTheme.of(context).typography.subtitle,
        ),
        const SizedBox(height: 16),
        
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Automatic Backups',
                  style: FluentTheme.of(context).typography.bodyStrong,
                ),
                const SizedBox(height: 8),
                Text(
                  'Configure automatic backup settings for your clinic data.',
                  style: FluentTheme.of(context).typography.body,
                ),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: InfoLabel(
                        label: 'Backup Frequency',
                        child: ComboBox<String>(
                          placeholder: const Text('Select frequency'),
                          items: const [
                            ComboBoxItem(
                              value: 'daily',
                              child: Text('Daily'),
                            ),
                            ComboBoxItem(
                              value: 'weekly',
                              child: Text('Weekly'),
                            ),
                            ComboBoxItem(
                              value: 'monthly',
                              child: Text('Monthly'),
                            ),
                          ],
                          onChanged: (value) {},
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InfoLabel(
                        label: 'Backup Location',
                        child: TextBox(
                          placeholder: 'Enter backup path',
                          suffix: IconButton(
                            icon: const Icon(FluentIcons.folder_open),
                            onPressed: () {
                              // Open folder picker
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    FilledButton(
                      child: const Text('Create Backup Now'),
                      onPressed: () {
                        // Create immediate backup
                      },
                    ),
                    const SizedBox(width: 8),
                    Button(
                      child: const Text('Restore from Backup'),
                      onPressed: () {
                        // Restore from backup
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recent Backups',
                  style: FluentTheme.of(context).typography.bodyStrong,
                ),
                const SizedBox(height: 16),
                
                // Mock recent backups list
                ...List.generate(3, (index) => ListTile(
                  leading: const Icon(FluentIcons.archive),
                  title: Text('Backup ${DateTime.now().subtract(Duration(days: index)).toString().substring(0, 10)}'),
                  subtitle: Text('Size: ${(index + 1) * 1.2}MB'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(FluentIcons.download),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(FluentIcons.delete),
                        onPressed: () {},
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}