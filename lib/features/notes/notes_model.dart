import '../core/model.dart';

class Note extends Model {
  String content = '';
  String date = '';
  String authorID = '';

  Note.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  @override
  void fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    if (json['content'] != null) content = json['content'];
    if (json['date'] != null) date = json['date'];
    if (json['authorID'] != null) authorID = json['authorID'];
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['content'] = content;
    json['date'] = date;
    json['authorID'] = authorID;
    return json;
  }

  @override
  Note copy(bool blank) {
    return Note.fromJson(blank ? {} : toJson());
  }

  @override
  Map<String, dynamic> get jsonCopyForPush => toJson();

  @override
  List<String> get targetsToPushTo => ['notes'];

  @override
  List<String> get pushIfChanged => ['title', 'content', 'date', 'authorID'];

  @override
  bool get pushOnCreation => true;
}