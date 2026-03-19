import 'package:arcdse/services/archived.dart';
import 'package:arcdse/services/localization/locale.dart';
import 'package:fluent_ui/fluent_ui.dart';

/// A toggle button that shows/hides archived items in a list.
class ArchiveToggle extends StatelessWidget {
  /// Optional stream to rebuild when synced from outside.
  final Stream? notifier;
  const ArchiveToggle({super.key, this.notifier});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: showArchived.stream,
      builder: (context, _) {
        return ToggleButton(
          checked: showArchived(),
          onChanged: (v) => showArchived(v),
          child: Text(txt("showHideArchived")),
        );
      },
    );
  }
}
