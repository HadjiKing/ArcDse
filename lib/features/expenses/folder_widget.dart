import 'package:arcdse/services/localization/locale.dart';
import 'package:fluent_ui/fluent_ui.dart';

/// A folder-shaped tile used in the expenses grid.
class Folder extends StatelessWidget {
  final bool isArchived;
  final IconData icon;
  final String title;
  final String subtitle;
  final AccentColor color;
  final VoidCallback onOpen;
  final void Function(String newName) onRename;
  final VoidCallback onArchive;

  const Folder({
    super.key,
    required this.isArchived,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onOpen,
    required this.onRename,
    required this.onArchive,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onOpen,
      child: FlyoutTarget(
        controller: FlyoutController(),
        child: _FolderContent(
          isArchived: isArchived,
          icon: icon,
          title: title,
          subtitle: subtitle,
          color: color,
          onOpen: onOpen,
          onRename: onRename,
          onArchive: onArchive,
        ),
      ),
    );
  }
}

class _FolderContent extends StatefulWidget {
  final bool isArchived;
  final IconData icon;
  final String title;
  final String subtitle;
  final AccentColor color;
  final VoidCallback onOpen;
  final void Function(String) onRename;
  final VoidCallback onArchive;

  const _FolderContent({
    required this.isArchived,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onOpen,
    required this.onRename,
    required this.onArchive,
  });

  @override
  State<_FolderContent> createState() => _FolderContentState();
}

class _FolderContentState extends State<_FolderContent> {
  final _flyoutCtrl = FlyoutController();

  @override
  Widget build(BuildContext context) {
    return FlyoutTarget(
      controller: _flyoutCtrl,
      child: GestureDetector(
        onSecondaryTap: _showContextMenu,
        onLongPress: _showContextMenu,
        onTap: widget.onOpen,
        child: Opacity(
          opacity: widget.isArchived ? 0.45 : 1,
          child: Container(
            decoration: BoxDecoration(
              color: widget.color.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: widget.color, width: 1),
            ),
            padding: const EdgeInsets.all(6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon, color: widget.color, size: 28),
                const SizedBox(height: 4),
                Text(
                  widget.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 11),
                ),
                Text(
                  widget.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showContextMenu() {
    _flyoutCtrl.showFlyout(builder: (ctx) {
      return MenuFlyout(items: [
        MenuFlyoutItem(
          text: Text(txt("open")),
          leading: const Icon(FluentIcons.open_folder_horizontal),
          onPressed: widget.onOpen,
        ),
        MenuFlyoutItem(
          text: Text(txt("rename")),
          leading: const Icon(FluentIcons.rename),
          onPressed: () {
            Navigator.of(ctx).pop();
            _showRenameDialog();
          },
        ),
        MenuFlyoutItem(
          text: Text(widget.isArchived ? txt("restore") : txt("archive")),
          leading: const Icon(FluentIcons.archive),
          onPressed: widget.onArchive,
        ),
      ]);
    });
  }

  void _showRenameDialog() {
    final ctrl = TextEditingController(text: widget.title);
    showDialog(
      context: context,
      builder: (_) => ContentDialog(
        title: Text(txt("rename")),
        content: TextBox(controller: ctrl),
        actions: [
          FilledButton(
            onPressed: () {
              widget.onRename(ctrl.text);
              Navigator.of(context).pop();
            },
            child: Text(txt("save")),
          ),
          Button(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(txt("cancel")),
          ),
        ],
      ),
    );
  }
}
