import 'package:arcdse/core/model.dart';

// Import appointments store for computed appointment-based properties.
// This forms a compile-time cycle with appointments_store → demo_generator
// → patient_model → appointments_store, which is safe in Dart because the
// top-level singleton initialisers do not cross-call each other.
import 'package:arcdse/features/appointments/appointments_store.dart';
import 'package:arcdse/features/appointments/appointment_model.dart';

class Patient extends Model {
  List<String> tags = [];
  String phone = '';
  String address = '';
  int birthYear = 0;
  String gender = 'male';
  String webPageLink = '';

  Patient.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  @override
  void fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    tags = List<String>.from(json['tags'] ?? []);
    phone = (json['phone'] as String?) ?? '';
    address = (json['address'] as String?) ?? '';
    birthYear = (json['birthYear'] as int?) ?? 0;
    gender = (json['gender'] as String?) ?? 'male';
    webPageLink = (json['webPageLink'] as String?) ?? '';
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['tags'] = tags;
    json['phone'] = phone;
    json['address'] = address;
    json['birthYear'] = birthYear;
    json['gender'] = gender;
    json['webPageLink'] = webPageLink;
    return json;
  }

  @override
  Patient copy(bool blank) {
    return Patient.fromJson(blank ? {} : toJson());
  }

  /// Calculated age in years based on [birthYear].
  int get age {
    if (birthYear == 0) return 0;
    return DateTime.now().year - birthYear;
  }

  List<Appointment> get _allAppointments {
    return appointments.byPatient[id]?['all'] ?? [];
  }

  /// All appointments for this patient (both past and upcoming).
  List<Appointment> get allAppointments => _allAppointments;

  /// All appointments for this patient that are marked as done.
  List<Appointment> get doneAppointments {
    return appointments.byPatient[id]?['done'] ?? [];
  }

  /// Merged dental-notes map across all done appointments (last-write wins per
  /// tooth key).
  Map<String, String> get allAppointmentsDentalNotes {
    final result = <String, String>{};
    for (final appt in _allAppointments) {
      result.addAll(appt.teeth);
    }
    return result;
  }

  /// All appointments for this patient that have at least one image attached.
  List<Appointment> get appointmentsWithImages {
    return _allAppointments.where((a) => a.imgs.isNotEmpty).toList();
  }
}
