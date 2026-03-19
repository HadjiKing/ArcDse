import 'package:arcdse/features/accounts/accounts_controller.dart';
import 'package:arcdse/services/localization/locale.dart';
import 'package:fluent_ui/fluent_ui.dart';

/// Lets the user assign one or more operators to an item (e.g. appointment).
class OperatorsPicker extends StatelessWidget {
  final List<String> value;
  final void Function(List<String>) onChanged;

  const OperatorsPicker({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final operators = accounts.operators;
    return Wrap(
      spacing: 4,
      children: operators.map((op) {
        final id = op.id;
        final selected = value.contains(id);
        return ToggleButton(
          checked: selected,
          onChanged: (_) {
            final updated = List<String>.from(value);
            if (selected) {
              updated.remove(id);
            } else {
              updated.add(id);
            }
            onChanged(updated);
          },
          child: Text(accounts.name(op)),
        );
      }).toList(),
    );
  }
}
