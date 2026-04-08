import 'package:arcdse/app/routes.dart';
import 'package:arcdse/features/patients/patient_model.dart';
import 'package:arcdse/features/patients/patients_store.dart';
import 'package:arcdse/services/localization/locale.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';

/// Opens the patient panel for [patient], creating a new one if not supplied.
///
/// Returns a [Future] that completes with the edited [Patient] when the panel
/// is saved (or closed).
Future<Patient?> openPatient([Patient? patient]) {
  final editingCopy = Patient.fromJson(patient?.toJson() ?? {});
  final panel = Panel(
    item: editingCopy,
    store: patients,
    icon: FluentIcons.contact,
    title: patients.get(editingCopy.id) == null
        ? txt("addPatient")
        : editingCopy.title,
    tabs: [
      PanelTab(
        title: txt("patient"),
        icon: FluentIcons.contact,
        body: _PatientDetails(editingCopy),
      ),
    ],
  );
  routes.openPanel(panel);
  return panel.result.future;
}

class _PatientDetails extends StatefulWidget {
  final Patient patient;
  const _PatientDetails(this.patient);

  @override
  State<_PatientDetails> createState() => _PatientDetailsState();
}

class _PatientDetailsState extends State<_PatientDetails> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _birthCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.patient.title);
    _phoneCtrl = TextEditingController(text: widget.patient.phone);
    _addressCtrl = TextEditingController(text: widget.patient.address);
    _birthCtrl = TextEditingController(
      text: widget.patient.birthYear == 0
          ? ''
          : widget.patient.birthYear.toString(),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _birthCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoLabel(
          label: "${txt("name")}:",
          child: CupertinoTextField(
            controller: _nameCtrl,
            placeholder: txt("name"),
            onChanged: (v) => widget.patient.title = v,
          ),
        ),
        const SizedBox(height: 10),
        InfoLabel(
          label: "${txt("phone")}:",
          child: CupertinoTextField(
            controller: _phoneCtrl,
            placeholder: txt("phone"),
            keyboardType: TextInputType.phone,
            onChanged: (v) => widget.patient.phone = v,
          ),
        ),
        const SizedBox(height: 10),
        InfoLabel(
          label: "${txt("address")}:",
          child: CupertinoTextField(
            controller: _addressCtrl,
            placeholder: txt("address"),
            onChanged: (v) => widget.patient.address = v,
          ),
        ),
        const SizedBox(height: 10),
        InfoLabel(
          label: "${txt("birthYear")}:",
          child: CupertinoTextField(
            controller: _birthCtrl,
            placeholder: txt("birthYear"),
            keyboardType: TextInputType.number,
            onChanged: (v) =>
                widget.patient.birthYear = int.tryParse(v) ?? 0,
          ),
        ),
        const SizedBox(height: 10),
        InfoLabel(
          label: "${txt("gender")}:",
          child: ComboBox<String>(
            value: widget.patient.gender,
            items: ['male', 'female']
                .map((g) => ComboBoxItem(value: g, child: Text(txt(g))))
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => widget.patient.gender = v);
            },
          ),
        ),
      ],
    );
  }
}
