import 'package:arcdse/features/appointments/appointments_store.dart';
import 'package:arcdse/features/patients/patient_model.dart';
import 'package:arcdse/features/patients/patients_store.dart';
import 'package:arcdse/features/appointments/appointment_model.dart';

class _DashboardController {
  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// All appointments scheduled for today.
  List<Appointment> get todayAppointments {
    final now = DateTime.now();
    return appointments.filtered.values
        .where((a) => _isSameDay(a.date, now))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  /// Patients whose first-ever appointment falls today.
  List<Patient> get newPatientsToday {
    final now = DateTime.now();
    final result = <Patient>[];
    for (final patient in patients.present.values) {
      final all = patient.allAppointments;
      if (all.isEmpty) continue;
      final sorted = List<Appointment>.from(all)
        ..sort((a, b) => a.date.compareTo(b.date));
      if (_isSameDay(sorted.first.date, now)) {
        result.add(patient);
      }
    }
    return result;
  }

  /// Total amount paid across all completed appointments today.
  double get paymentsToday {
    final now = DateTime.now();
    return appointments.filtered.values
        .where((a) => a.isDone && _isSameDay(a.date, now))
        .fold(0.0, (sum, a) => sum + a.paid);
  }
}

final dashboardCtrl = _DashboardController();
