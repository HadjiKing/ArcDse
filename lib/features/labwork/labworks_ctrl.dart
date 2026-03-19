import '../appointments/appointments_store.dart';
import '../appointments/appointment_model.dart';

class LabworkItem {
  final Appointment appointment;
  final String patientName;
  final String labName;
  final DateTime dueDate;
  final bool isOverdue;

  LabworkItem({
    required this.appointment,
    required this.patientName,
    required this.labName,
    required this.dueDate,
    required this.isOverdue,
  });
}

class _LabworksController {
  List<LabworkItem> get due {
    final now = DateTime.now();
    final allAppointments = appointments.observableMap.values;
    
    return allAppointments
        .where((appointment) => appointment.hasLabwork && !appointment.isDone)
        .map((appointment) {
          final dueDate = appointment.date.add(const Duration(days: 7)); // Lab work due 7 days after appointment
          return LabworkItem(
            appointment: appointment,
            patientName: appointment.subtitleLine1, // This would be populated from patients store
            labName: appointment.labName,
            dueDate: dueDate,
            isOverdue: dueDate.isBefore(now),
          );
        })
        .toList()
        ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
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