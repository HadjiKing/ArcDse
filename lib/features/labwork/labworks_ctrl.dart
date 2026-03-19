import 'package:arcdse/features/appointments/appointment_model.dart';
import 'package:arcdse/features/appointments/appointments_store.dart';
import 'package:arcdse/features/patients/patient_model.dart';
import 'package:arcdse/features/patients/patients_store.dart';

class _LabworksCtrl {
  /// Appointments that have labwork ordered but not yet received from the lab.
  List<Appointment> get due {
    return appointments.present.values
        .where((a) => a.hasLabwork && !a.labworkReceived)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  /// Patients whose last done appointment has labwork that was received but
  /// the appointment is still marked as pending delivery.
  List<Patient> get notDelivered {
    final result = <Patient>[];
    for (final patient in patients.present.values) {
      final done = patient.doneAppointments;
      if (done.isEmpty) continue;
      final hasUndelivered = done.any((a) => a.hasLabwork && a.labworkReceived);
      if (hasUndelivered) result.add(patient);
    }
    return result;
  }
}

final labworks = _LabworksCtrl();
