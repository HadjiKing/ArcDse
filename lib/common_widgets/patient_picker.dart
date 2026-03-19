import 'package:arcdse/features/patients/patients_store.dart';
import 'package:arcdse/services/localization/locale.dart';
import 'package:fluent_ui/fluent_ui.dart';

/// An auto-suggest box for picking a patient by name.
class PatientPicker extends StatelessWidget {
  final String? value;
  final void Function(String? id) onChanged;

  const PatientPicker({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selected =
        value != null ? patients.get(value!) : null;
    return AutoSuggestBox<String>(
      placeholder: txt("searchPatient"),
      clearButtonEnabled: true,
      controller: TextEditingController(text: selected?.title ?? ''),
      items: patients.present.values
          .map((p) => AutoSuggestBoxItem<String>(value: p.id, label: p.title))
          .toList(),
      onSelected: (item) => onChanged(item.value),
    );
  }
}
