import '../appointments/appointments_store.dart';
import '../patients/patients_store.dart';
import '../appointments/appointment_model.dart';
import '../patients/patient_model.dart';

class _DashboardController {
  List<Appointment> get todayAppointments {
    final today = DateTime.now();
    final allAppointments = appointments.observableMap.values;
    
    return allAppointments.where((appointment) {
      final appointmentDate = appointment.date;
      return appointmentDate.year == today.year &&
             appointmentDate.month == today.month &&
             appointmentDate.day == today.day;
    }).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  List<Patient> get newPatientsToday {
    final today = DateTime.now();
    final todayString = today.toIso8601String().substring(0, 10); // YYYY-MM-DD
    
    return patients.observableMap.values.where((patient) {
      if (patient.lastVisitDate == null) return false;
      return patient.lastVisitDate!.startsWith(todayString);
    }).toList();
  }

  double get todayRevenue {
    return todayAppointments
        .where((appointment) => appointment.isDone)
        .fold(0.0, (sum, appointment) => sum + appointment.paid);
  }

  int get totalPatientsCount => patients.observableMap.values.length;

  int get upcomingAppointmentsCount {
    final now = DateTime.now();
    return appointments.observableMap.values
        .where((appointment) => appointment.date.isAfter(now) && !appointment.isDone)
        .length;
  }

  List<Appointment> get recentAppointments {
    final allAppointments = appointments.observableMap.values.toList();
    allAppointments.sort((a, b) => b.date.compareTo(a.date));
    return allAppointments.take(5).toList();
  }

  double get totalRevenue {
    return appointments.observableMap.values
        .where((appointment) => appointment.isDone)
        .fold(0.0, (sum, appointment) => sum + appointment.paid);
  }
}

final dashboardCtrl = _DashboardController();