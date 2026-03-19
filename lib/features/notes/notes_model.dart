import 'package:arcdse/core/model.dart';

class Note extends Model {
  String content = '';
  DateTime date = DateTime.now();
  String patientID = '';
  String operatorID = '';

  Note.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  @override
  void fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    content = (json['content'] as String?) ?? '';
    if (json['date'] != null) {
      date = DateTime.tryParse(json['date'].toString()) ?? DateTime.now();
    }
    patientID = (json['patientID'] as String?) ?? '';
    operatorID = (json['operatorID'] as String?) ?? '';
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['content'] = content;
    json['date'] = date.toIso8601String();
    json['patientID'] = patientID;
    json['operatorID'] = operatorID;
    return json;
  }

  @override
  Note copy(bool blank) {
    return Note.fromJson(blank ? {} : toJson());
  }
}
