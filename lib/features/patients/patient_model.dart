import '../appointments/appointment_model.dart';
import '../appointments/appointments_store.dart';
import '../core/model.dart';

class Patient extends Model {
  String phone = '';
  String email = '';
  int age = 0;
  String gender = 'M'; // 'M' or 'F'
  String address = '';
  List<String> tags = [];
  String notes = '';
  String? lastVisitDate;

  @override
  String get title => name;
  
  String get name => super.title;
  set name(String value) => super.title = value;

  // Appointment accessors via the appointments store
  List<Appointment> get allAppointments =>
      appointments.byPatient[id]?["all"] ?? [];

  List<Appointment> get doneAppointments =>
      appointments.byPatient[id]?["done"] ?? [];

  String get subtitleLine1 => phone.isNotEmpty ? phone : email;
  
  String get subtitleLine2 {
    List<String> parts = [];
    if (age > 0) parts.add('$age years');
    if (gender == 'F') parts.add('Female');
    else parts.add('Male');
    return parts.join(' • ');
  }

  Patient.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  @override
  void fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    if (json['phone'] != null) phone = json['phone'];
    if (json['email'] != null) email = json['email'];
    if (json['age'] != null) age = json['age'];
    if (json['gender'] != null) gender = json['gender'];
    if (json['address'] != null) address = json['address'];
    if (json['tags'] != null) tags = List<String>.from(json['tags']);
    if (json['notes'] != null) notes = json['notes'];
    if (json['lastVisitDate'] != null) lastVisitDate = json['lastVisitDate'];
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['phone'] = phone;
    json['email'] = email;
    json['age'] = age;
    json['gender'] = gender;
    json['address'] = address;
    json['tags'] = tags;
    json['notes'] = notes;
    if (lastVisitDate != null) json['lastVisitDate'] = lastVisitDate;
    return json;
  }

  @override
  Patient copy(bool blank) {
    return Patient.fromJson(blank ? {} : toJson());
  }

  @override
  Map<String, dynamic> get jsonCopyForPush => toJson();

  @override
  List<String> get targetsToPushTo => ['patients'];

  @override
  List<String> get pushIfChanged => ['title', 'phone', 'email', 'age', 'gender', 'address', 'tags', 'notes', 'lastVisitDate'];

  @override
  bool get pushOnCreation => true;
}