import 'dart:convert';
import 'dart:math';

import 'package:arcdse/features/appointments/appointment_model.dart';
import 'package:arcdse/features/expenses/expense_model.dart';
import 'package:arcdse/features/patients/patient_model.dart';
import 'package:arcdse/utils/uuid.dart';
import 'package:pocketbase/pocketbase.dart';

// ---------------------------------------------------------------------------
// Shared seed data
// ---------------------------------------------------------------------------

const _firstNamesAr = [
  'أحمد', 'محمد', 'علي', 'عمر', 'خالد', 'يوسف', 'إبراهيم', 'عبدالله',
  'سعيد', 'مصطفى', 'فاطمة', 'سارة', 'مريم', 'نور', 'هنا', 'رنا',
  'ليلى', 'رهف', 'دانا', 'لينا',
];

const _firstNamesEn = [
  'James', 'John', 'Robert', 'Michael', 'William', 'David', 'Emma',
  'Olivia', 'Ava', 'Sophia', 'Isabella', 'Mia', 'Charlotte', 'Amelia',
  'Harper', 'Evelyn', 'Lucas', 'Mason', 'Ethan', 'Logan',
];

const _lastNames = [
  'Smith', 'Johnson', 'Williams', 'Jones', 'Brown', 'Davis', 'Miller',
  'Wilson', 'Moore', 'Taylor', 'Anderson', 'Thomas', 'Jackson', 'White',
  'Harris', 'Martin', 'Thompson', 'Garcia', 'Martinez', 'Robinson',
  'الشمري', 'العتيبي', 'الحربي', 'الدوسري', 'المطيري', 'الزهراني',
  'القحطاني', 'الغامدي', 'البلوي', 'العمري',
];

const _tags = ['new', 'regular', 'vip', 'referred', 'child', 'senior', 'followup'];

const _supplierNames = [
  '3M Dental',
  'Dentsply Sirona',
  'GC America',
  'Kerr Dental',
  'DENTSPLY',
  'Ivoclar Vivadent',
  'SDI Limited',
  'Ultradent Products',
  'Shofu Dental',
  'Nobel Biocare',
];

const _expenseItems = [
  'Composite resin',
  'Bonding agent',
  'Dental burs',
  'Impression material',
  'Anesthetic cartridges',
  'Gloves (box)',
  'Face masks (box)',
  'Suction tips',
  'Dental floss (roll)',
  'X-ray films',
  'Orthodontic brackets',
  'Dental crowns',
  'Implant fixtures',
  'Root canal files',
  'Rubber dam',
];

const _prescriptions = [
  'Amoxicillin 500mg',
  'Ibuprofen 400mg',
  'Metronidazole 500mg',
  'Paracetamol 500mg',
  'Chlorhexidine mouthwash',
  'Dexamethasone 4mg',
];

const _labNames = [
  'Crown Lab',
  'PerfectSmile Lab',
  'DentaCraft',
  'ProDental',
  'Elite Dental Lab',
];

const _accountNames = [
  'Dr. Sarah Johnson',
  'Dr. Ahmed Al-Rashid',
  'Dr. Maria Garcia',
  'Dr. James Wilson',
  'Dr. Fatima Al-Zahra',
  'Nurse Emily Davis',
  'Receptionist Tom Brown',
  'Dr. Omar Hassan',
  'Dr. Lisa Chen',
  'Admin Alex Taylor',
];

// ---------------------------------------------------------------------------
// Deterministic helpers
// ---------------------------------------------------------------------------

T _pick<T>(List<T> list, int seed) => list[seed.abs() % list.length];

String _deterministicId(String prefix, int index) {
  final rand = Random(index * 31337 + prefix.hashCode);
  final buf = StringBuffer();
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  for (int i = 0; i < 15; i++) {
    buf.write(chars[rand.nextInt(chars.length)]);
  }
  return buf.toString();
}

// ---------------------------------------------------------------------------
// Patient demo data
// ---------------------------------------------------------------------------

List<Patient> demoPatients(int count) {
  final rand = Random(42);
  return List.generate(count, (i) {
    final isArabic = i % 3 == 0;
    final firstName =
        isArabic ? _pick(_firstNamesAr, i) : _pick(_firstNamesEn, i);
    final lastName = _pick(_lastNames, i + 5);
    final name = '$firstName $lastName';

    final tagCount = (i % 3) + 1;
    final tags = List.generate(tagCount, (t) => _pick(_tags, i + t));

    final birthYear = 1960 + (i % 50);
    final gender = i % 3 == 2 ? 'female' : 'male';

    return Patient.fromJson({
      'id': _deterministicId('p', i),
      'title': name,
      'tags': tags,
      'phone': '05${(50000000 + i * 37).toString().substring(0, 8)}',
      'address': 'Street ${i % 100 + 1}, Building ${i % 20 + 1}',
      'birthYear': birthYear,
      'gender': gender,
      'webPageLink': '',
    });
  });
}

// ---------------------------------------------------------------------------
// Appointment demo data
// ---------------------------------------------------------------------------

List<Appointment> demoAppointments(int count) {
  // We need patient IDs; generate the same deterministic IDs used above.
  final patientIds =
      List.generate(100, (i) => _deterministicId('p', i));

  final now = DateTime.now();

  return List.generate(count, (i) {
    final rand = Random(i * 13 + 7);

    final daysOffset = (i % 730) - 365; // spread ±1 year around today
    final date = now.add(Duration(days: daysOffset));
    final isDone = daysOffset < 0 && i % 3 != 0;
    final price = (rand.nextInt(20) + 5) * 50.0;
    final paid = isDone
        ? (rand.nextBool() ? price : price * (rand.nextInt(9) + 1) / 10)
        : 0.0;

    final operatorCount = (i % 2) + 1;
    final operatorIds =
        List.generate(operatorCount, (o) => _deterministicId('acc', o));

    final hasPrescription = isDone && i % 4 == 0;
    final prescriptions = hasPrescription
        ? [_pick(_prescriptions, i), if (i % 8 == 0) _pick(_prescriptions, i + 2)]
        : <String>[];

    final hasLab = i % 7 == 0;

    final teethCount = isDone ? (i % 4) : 0;
    final teeth = <String, String>{};
    for (int t = 0; t < teethCount; t++) {
      teeth['${11 + t}'] = _pick(['C', 'R', 'E', 'F', 'M'], t);
    }

    return Appointment.fromJson({
      'id': _deterministicId('a', i),
      'patientID': _pick(patientIds, i),
      'date': date.toIso8601String(),
      'isDone': isDone,
      'hasLabwork': hasLab,
      'labName': hasLab ? _pick(_labNames, i) : '',
      'labworkNotes': hasLab ? 'Crown for tooth ${11 + i % 5}' : '',
      'labworkReceived': hasLab && isDone && i % 2 == 0,
      'operatorsIDs': operatorIds,
      'prescriptions': prescriptions,
      'preOpNotes': isDone ? 'Pre-op note ${i % 10}' : '',
      'postOpNotes': isDone ? 'Post-op note ${i % 10}' : '',
      'price': price,
      'paid': paid,
      'imgs': <String>[],
      'teeth': teeth,
      'drawings': <String, dynamic>{},
    });
  });
}

// ---------------------------------------------------------------------------
// Expense demo data
// ---------------------------------------------------------------------------

List<Expense> demoExpenses(int count) {
  // First, generate a handful of supplier records.
  final supplierCount = min(10, count ~/ 4);
  final supplierIds =
      List.generate(supplierCount, (i) => _deterministicId('sup', i));

  final expenses = <Expense>[];

  // Add supplier folders.
  for (int i = 0; i < supplierCount; i++) {
    expenses.add(Expense.fromJson({
      'id': supplierIds[i],
      'title': _pick(_supplierNames, i),
      'isSupplier': true,
    }));
  }

  // Add orders linked to suppliers.
  final orderCount = count - supplierCount;
  final now = DateTime.now();
  for (int i = 0; i < orderCount; i++) {
    final rand = Random(i * 17 + 3);
    final itemCount = rand.nextInt(4) + 1;
    final items = List.generate(
        itemCount, (t) => _pick(_expenseItems, i * 3 + t));
    final cost = (rand.nextInt(40) + 5) * 25.0;
    final processed = i % 3 != 0;
    final daysOffset = -(i % 365);
    final date = now.add(Duration(days: daysOffset));

    expenses.add(Expense.fromJson({
      'id': _deterministicId('exp', i),
      'supplierId': _pick(supplierIds, i),
      'isSupplier': false,
      'processed': processed,
      'cost': cost,
      'items': items,
      'date': date.toIso8601String(),
      'notes': i % 5 == 0 ? 'Urgent order' : '',
    }));
  }

  return expenses;
}

// ---------------------------------------------------------------------------
// Account (user) demo data
// ---------------------------------------------------------------------------

List<RecordModel> demoAccounts(int count) {
  return List.generate(count, (i) {
    final name = _pick(_accountNames, i);
    final isAdmin = i == 0;
    final operate = i < 5 ? 1 : 0;

    return RecordModel.fromJson({
      'id': _deterministicId('acc', i),
      'collectionId': isAdmin ? '_superusers' : 'users',
      'collectionName': isAdmin ? '_superusers' : 'users',
      'created': '2024-01-01 00:00:00',
      'updated': '2024-01-01 00:00:00',
      'name': name,
      'email': 'demo${i + 1}@arcdse.app',
      'operate': operate,
      'permissions': jsonEncode([2, 2, 2, 2, 2, 2, 1, 1]),
      'type': isAdmin ? 'admin' : 'user',
    });
  });
}
