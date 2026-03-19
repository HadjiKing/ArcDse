import '../core/model.dart';

class Expense extends Model {
  bool isSupplier = false;
  String supplierID = '';
  bool processed = false;
  double cost = 0.0;
  String date = '';
  List<String> items = [];
  String notes = '';

  // Computed properties
  bool get isOrder => !isSupplier;

  Expense.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  @override
  void fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    if (json['isSupplier'] != null) isSupplier = json['isSupplier'];
    if (json['supplierID'] != null) supplierID = json['supplierID'];
    if (json['processed'] != null) processed = json['processed'];
    if (json['cost'] != null) cost = json['cost'].toDouble();
    if (json['date'] != null) date = json['date'];
    if (json['items'] != null) items = List<String>.from(json['items']);
    if (json['notes'] != null) notes = json['notes'];
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['isSupplier'] = isSupplier;
    json['supplierID'] = supplierID;
    json['processed'] = processed;
    json['cost'] = cost;
    json['date'] = date;
    json['items'] = items;
    json['notes'] = notes;
    return json;
  }

  @override
  Expense copy(bool blank) {
    return Expense.fromJson(blank ? {} : toJson());
  }

  @override
  Map<String, dynamic> get jsonCopyForPush => toJson();

  @override
  List<String> get targetsToPushTo => ['expenses'];

  @override
  List<String> get pushIfChanged => ['title', 'isSupplier', 'supplierID', 'processed', 'cost', 'date', 'items', 'notes'];

  @override
  bool get pushOnCreation => true;
}