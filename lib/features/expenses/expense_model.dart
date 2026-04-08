import 'package:arcdse/core/model.dart';
import 'package:arcdse/features/expenses/expenses_store.dart';

class Expense extends Model {
  bool isSupplier = false;
  String supplierId = '';
  bool processed = false;
  double cost = 0;
  List<String> items = [];
  DateTime date = DateTime.now();
  String notes = '';

  /// An expense record is either a supplier folder or an order (invoice).
  bool get isOrder => !isSupplier;

  /// Mutable alias for [title] used when renaming a supplier.
  String get supplierName => title;
  set supplierName(String value) => title = value;

  Expense.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  @override
  void fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    isSupplier = (json['isSupplier'] as bool?) ?? false;
    supplierId = (json['supplierId'] as String?) ?? '';
    processed = (json['processed'] as bool?) ?? false;
    cost = (json['cost'] as num?)?.toDouble() ?? 0;
    items = List<String>.from(json['items'] ?? []);
    if (json['date'] != null) {
      date = DateTime.tryParse(json['date'].toString()) ?? DateTime.now();
    }
    notes = (json['notes'] as String?) ?? '';
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['isSupplier'] = isSupplier;
    json['supplierId'] = supplierId;
    json['processed'] = processed;
    json['cost'] = cost;
    json['items'] = items;
    json['date'] = date.toIso8601String();
    json['notes'] = notes;
    return json;
  }

  @override
  Expense copy(bool blank) {
    return Expense.fromJson(blank ? {} : toJson());
  }

  /// Total unpaid order cost linked to this supplier.
  double get duePayments {
    if (!isSupplier) return 0;
    return expenses.present.values
        .where((e) => e.supplierId == id && e.isOrder && !e.processed)
        .fold(0.0, (sum, e) => sum + e.cost);
  }
}
