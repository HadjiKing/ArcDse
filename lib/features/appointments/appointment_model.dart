import 'package:arcdse/core/model.dart';
import 'package:arcdse/features/accounts/accounts_controller.dart';

// Import patients store for the `patient` computed property.
// The circular reference through demo_generator is safe because none of the
// top-level initialisers call across the boundary at construction time.
import 'package:arcdse/features/patients/patients_store.dart';

class Appointment extends Model {
  String? patientID;
  DateTime date = DateTime.now();
  bool isDone = false;
  bool hasLabwork = false;
  String labName = '';
  String labworkNotes = '';
  bool labworkReceived = false;
  List<String> operatorsIDs = [];
  List<String> prescriptions = [];
  String preOpNotes = '';
  String postOpNotes = '';
  double price = 0;
  double paid = 0;
  List<String> imgs = [];
  Map<String, String> teeth = {};
  Map<String, dynamic> drawings = {};

  // The Model.fromJson constructor calls the virtual fromJson() via dynamic
  // dispatch, so there is no need to call it again in the constructor body.
  Appointment.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  @override
  void fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    patientID = json['patientID'] as String?;
    if (json['date'] != null) {
      date = DateTime.tryParse(json['date'].toString()) ?? DateTime.now();
    }
    isDone = (json['isDone'] as bool?) ?? false;
    hasLabwork = (json['hasLabwork'] as bool?) ?? false;
    labName = (json['labName'] as String?) ?? '';
    labworkNotes = (json['labworkNotes'] as String?) ?? '';
    labworkReceived = (json['labworkReceived'] as bool?) ?? false;
    operatorsIDs = List<String>.from(json['operatorsIDs'] ?? []);
    prescriptions = List<String>.from(json['prescriptions'] ?? []);
    preOpNotes = (json['preOpNotes'] as String?) ?? '';
    postOpNotes = (json['postOpNotes'] as String?) ?? '';
    price = (json['price'] as num?)?.toDouble() ?? 0;
    paid = (json['paid'] as num?)?.toDouble() ?? 0;
    imgs = List<String>.from(json['imgs'] ?? []);
    teeth = Map<String, String>.from(json['teeth'] ?? {});
    drawings = Map<String, dynamic>.from(json['drawings'] ?? {});
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    if (patientID != null) json['patientID'] = patientID;
    json['date'] = date.toIso8601String();
    json['isDone'] = isDone;
    json['hasLabwork'] = hasLabwork;
    json['labName'] = labName;
    json['labworkNotes'] = labworkNotes;
    json['labworkReceived'] = labworkReceived;
    json['operatorsIDs'] = operatorsIDs;
    json['prescriptions'] = prescriptions;
    json['preOpNotes'] = preOpNotes;
    json['postOpNotes'] = postOpNotes;
    json['price'] = price;
    json['paid'] = paid;
    json['imgs'] = imgs;
    json['teeth'] = teeth;
    json['drawings'] = drawings;
    return json;
  }

  @override
  Appointment copy(bool blank) {
    return Appointment.fromJson(blank ? {} : toJson());
  }

  /// The patient associated with this appointment, looked up at runtime.
  Patient? get patient {
    if (patientID == null || patientID!.isEmpty) return null;
    return patients.get(patientID!);
  }

  @override
  String get title => patient?.title ?? patientID ?? '';

  /// Comma-separated names of operators assigned to this appointment.
  String get subtitleLine1 {
    if (operatorsIDs.isEmpty) return '';
    return operatorsIDs
        .map((id) => accounts.nameOrEmailFromID(id))
        .where((n) => n.isNotEmpty)
        .join(', ');
  }

  /// Price and paid-amount summary.
  String get subtitleLine2 {
    if (price == 0) return '';
    return 'Price: $price | Paid: $paid';
  }
}
