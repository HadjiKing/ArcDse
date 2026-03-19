import 'package:fluent_ui/fluent_ui.dart';

class ArchiveToggle extends StatelessWidget {
  final bool showArchived;
  final ValueChanged<bool> onChanged;

  const ArchiveToggle({
    super.key,
    required this.showArchived,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ToggleButton(
      checked: showArchived,
      onChanged: onChanged,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(showArchived ? FluentIcons.archive : FluentIcons.unarchive),
          const SizedBox(width: 8),
          Text(showArchived ? 'Hide Archived' : 'Show Archived'),
        ],
      ),
    );
  }
}