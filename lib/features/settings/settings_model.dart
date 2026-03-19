import '../core/model.dart';

class Setting extends Model {
  String value = '';

  Setting.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  @override
  void fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    if (json['value'] != null) value = json['value'];
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

  @override
  Map<String, dynamic> get jsonCopyForPush => toJson();

  @override
  List<String> get targetsToPushTo => ['settings'];

  @override
  List<String> get pushIfChanged => ['value'];

  @override
  bool get pushOnCreation => true;
}