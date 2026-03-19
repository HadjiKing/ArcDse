import 'package:fluent_ui/fluent_ui.dart';
import '../../app/routes.dart';
import 'patient_model.dart';
import 'patients_store.dart';

void openPatient(Patient? patient) {
  final editingCopy = patient != null 
      ? Patient.fromJson(patient.toJson()) 
      : Patient.fromJson({});
  
  final panel = Panel(
    item: editingCopy,
    store: patients,
    icon: FluentIcons.people,
    title: patient == null ? "New Patient" : editingCopy.name,
    tabs: [
      PanelTab(
        title: "Patient Details",
        icon: FluentIcons.person,
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Patient panel would go here"),
              Text("Name: ${editingCopy.name}"),
              Text("Phone: ${editingCopy.phone}"),
              Text("Email: ${editingCopy.email}"),
            ],
          ),
        ),
      ),
    ],
  );
  
  routes.openPanel(panel);
}