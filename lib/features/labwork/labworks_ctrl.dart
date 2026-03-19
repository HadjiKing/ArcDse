import '../appointments/appointments_store.dart';
import '../appointments/appointment_model.dart';
import '../patients/patient_model.dart';
import '../patients/patients_store.dart';
import '../../core/model.dart';

class LabworkItem extends Model {
  final Appointment appointment;
  final String patientName;
  final String labName;
  final DateTime dueDate;
  final bool isOverdue;
  final Patient? patient;

  // Alias expected by dashboard_screen
  DateTime get date => dueDate;

  LabworkItem({
    required this.appointment,
    required this.patientName,
    required this.labName,
    required this.dueDate,
    required this.isOverdue,
    this.patient,
  }) : super.fromJson({'id': appointment.id, 'title': patientName.isNotEmpty ? patientName : labName});
}

class _LabworksController {
  List<LabworkItem> get due {
    final now = DateTime.now();
    final allAppointments = appointments.observableMap.values;

    return allAppointments
        .where((appointment) => appointment.hasLabwork && !appointment.isDone)
        .map((appointment) {
          final dueDate = appointment.date.add(const Duration(days: 7));
          final pat = patients.observableMap.get(appointment.patientID ?? '');
          final patName = pat?.name ?? '';
          return LabworkItem(
            appointment: appointment,
            patientName: patName,
            labName: appointment.labName,
            dueDate: dueDate,
            isOverdue: dueDate.isBefore(now),
            patient: pat,
          );
        })
        .toList()
        ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  // Patients who have labwork on a done appointment but it hasn't been delivered
  List<Patient> get notDelivered {
    final Set<String> patientIds = appointments.observableMap.values
        .where((a) => a.hasLabwork && a.isDone && a.labName.isNotEmpty)
        .map((a) => a.patientID ?? '')
        .where((id) => id.isNotEmpty)
        .toSet();
    return patientIds
        .map((id) => patients.observableMap.get(id))
        .whereType<Patient>()
        .toList();
  }

  List<LabworkItem> get overdue {
    return due.where((item) => item.isOverdue).toList();
  }

  List<LabworkItem> get upcoming {
    return due.where((item) => !item.isOverdue).toList();
  }

  int get overdueCount => overdue.length;

  int get upcomingCount => upcoming.length;
}

final labworks = _LabworksController();