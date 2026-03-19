import '../core/model.dart';

class Appointment extends Model {
  String patientID = '';
  DateTime date = DateTime.now();
  double price = 0.0;
  double paid = 0.0;
  bool isDone = false;
  bool hasLabwork = false;
  String labName = '';
  List<String> operatorsIDs = [];
  List<String> prescriptions = [];
  String notes = '';
  List<int> tx = []; // teeth treatment array

  // Computed properties for display
  String get subtitleLine1 {
    // This would be populated by getting the patient name from patients store
    return patientID; // placeholder
  }

  String get subtitleLine2 {
    // This would show the doctor names from operatorsIDs
    return operatorsIDs.join(', '); // placeholder
  }

  Appointment.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  @override
  void fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    if (json['patientID'] != null) patientID = json['patientID'];
    if (json['date'] != null) {
      // Handle date from milliseconds/60000 format
      if (json['date'] is int) {
        date = DateTime.fromMillisecondsSinceEpoch((json['date'] as int) * 60000);
      } else if (json['date'] is String) {
        date = DateTime.parse(json['date']);
      }
    }
    if (json['price'] != null) price = json['price'].toDouble();
    if (json['paid'] != null) paid = json['paid'].toDouble();
    if (json['isDone'] != null) isDone = json['isDone'];
    if (json['hasLabwork'] != null) hasLabwork = json['hasLabwork'];
    if (json['labName'] != null) labName = json['labName'];
    if (json['operatorsIDs'] != null) operatorsIDs = List<String>.from(json['operatorsIDs']);
    if (json['prescriptions'] != null) prescriptions = List<String>.from(json['prescriptions']);
    if (json['notes'] != null) notes = json['notes'];
    if (json['tx'] != null) tx = List<int>.from(json['tx']);
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['patientID'] = patientID;
    json['date'] = (date.millisecondsSinceEpoch / 60000).round(); // Convert to minutes
    json['price'] = price;
    json['paid'] = paid;
    json['isDone'] = isDone;
    json['hasLabwork'] = hasLabwork;
    json['labName'] = labName;
    json['operatorsIDs'] = operatorsIDs;
    json['prescriptions'] = prescriptions;
    json['notes'] = notes;
    json['tx'] = tx;
    return json;
  }

  @override
  Appointment copy(bool blank) {
    return Appointment.fromJson(blank ? {} : toJson());
  }

  @override
  Map<String, dynamic> get jsonCopyForPush => toJson();

  @override
  List<String> get targetsToPushTo => ['appointments'];

  @override
  List<String> get pushIfChanged => ['patientID', 'date', 'price', 'paid', 'isDone', 'hasLabwork', 'labName', 'operatorsIDs', 'prescriptions', 'notes', 'tx'];

  @override
  bool get pushOnCreation => true;
}