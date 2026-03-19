import 'package:arcdse/core/model.dart';

class Setting extends Model {
  String value = '';

  Setting.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  @override
  void fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    value = (json['value'] as String?) ?? '';
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['value'] = value;
    return json;
  }

  @override
  Setting copy(bool blank) {
    return Setting.fromJson(blank ? {} : toJson());
  }
}
