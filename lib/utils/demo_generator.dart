import 'dart:math';
import 'package:pocketbase/pocketbase.dart';
import '../features/appointments/appointment_model.dart';
import '../features/patients/patient_model.dart';
import '../features/expenses/expense_model.dart';
import '../features/notes/notes_model.dart';
import '../utils/uuid.dart';

final _random = Random();

// Arabic and Western names for realistic demo data
const _arabicNames = [
  'أحمد محمد', 'فاطمة أحمد', 'محمد عبدالله', 'عائشة علي', 'علي حسن',
  'مريم خالد', 'يوسف إبراهيم', 'زينب محمود', 'حسام الدين', 'نور الهدى',
  'عبدالرحمن سالم', 'هدى عبدالله', 'كريم محمد', 'آمال أحمد', 'طارق علي'
];

const _westernNames = [
  'John Smith', 'Sarah Johnson', 'Michael Brown', 'Emma Davis', 'David Wilson',
  'Olivia Miller', 'James Moore', 'Sophia Taylor', 'Robert Anderson', 'Isabella Thomas',
  'William Jackson', 'Ava White', 'Alexander Harris', 'Mia Martin', 'Benjamin Thompson'
];

const _supplierNames = [
  'Dental Supply Co.', 'Medical Equipment Ltd.', 'Dental Tools Inc.',
  'ProDent Supplies', 'MediDental Corp.', 'Oral Care Distributors',
  'Dental Tech Solutions', 'SmileCare Supplies', 'DentMax Equipment'
];

const _dentalItems = [
  'Dental X-Ray Film', 'Composite Resin', 'Dental Burs', 'Impression Material',
  'Local Anesthetic', 'Dental Cotton', 'Surgical Gloves', 'Face Masks',
  'Dental Needles', 'Crown & Bridge Material', 'Root Canal Files',
  'Dental Cement', 'Polishing Paste', 'Fluoride Gel', 'Dental Floss'
];

const _prescriptions = [
  'Amoxicillin 500mg - Take 3 times daily for 7 days',
  'Ibuprofen 400mg - Take as needed for pain',
  'Chlorhexidine mouthwash - Rinse twice daily',
  'Paracetamol 500mg - Take every 6 hours as needed',
  'Metronidazole 400mg - Take twice daily for 5 days',
  'Aspirin 325mg - Take once daily',
  'Prednisolone 5mg - Take twice daily for 3 days'
];

List<Patient> demoPatients(int count) {
  final patients = <Patient>[];
  final allNames = [..._arabicNames, ..._westernNames];
  
  for (int i = 0; i < count; i++) {
    final patient = Patient.fromJson({});
    patient.name = allNames[_random.nextInt(allNames.length)];
    patient.phone = '+962 ${_random.nextInt(900) + 100} ${_random.nextInt(900000) + 100000}';
    patient.email = '${patient.name.toLowerCase().replaceAll(' ', '.')}@email.com';
    patient.age = _random.nextInt(70) + 10;
    patient.gender = _random.nextBool() ? 'M' : 'F';
    patient.address = 'Amman, Jordan';
    patient.tags = _random.nextBool() ? ['VIP'] : [];
    patient.notes = _random.nextBool() ? 'Regular patient' : '';
    
    // Set random last visit date within past year
    if (_random.nextBool()) {
      final daysAgo = _random.nextInt(365);
      patient.lastVisitDate = DateTime.now().subtract(Duration(days: daysAgo)).toIso8601String();
    }
    
    patients.add(patient);
  }
  
  return patients;
}

List<Appointment> demoAppointments(int count) {
  final appointments = <Appointment>[];
  
  for (int i = 0; i < count; i++) {
    final appointment = Appointment.fromJson({});
    appointment.patientID = uuid(); // Would be linked to actual patients
    
    // Random date within past 12 months and future 2 months
    final daysOffset = _random.nextInt(425) - 365; // -365 to +60 days
    appointment.date = DateTime.now().add(Duration(days: daysOffset));
    
    appointment.price = 50 + _random.nextDouble() * 250; // 50-300 USD
    appointment.paid = _random.nextBool() ? appointment.price : appointment.price * (_random.nextDouble() * 0.8 + 0.2);
    appointment.isDone = daysOffset < 0; // Past appointments are done
    appointment.hasLabwork = _random.nextBool();
    appointment.labName = appointment.hasLabwork ? 'Lab ${_random.nextInt(5) + 1}' : '';
    appointment.operatorsIDs = [uuid()]; // Would be linked to actual doctors
    
    if (_random.nextBool()) {
      appointment.prescriptions = [_prescriptions[_random.nextInt(_prescriptions.length)]];
    }
    
    appointment.notes = _random.nextBool() ? 'Regular checkup completed successfully' : '';
    appointment.title = 'Appointment ${i + 1}';
    
    // Random teeth treatments (32 teeth, multiple treatments possible)
    appointment.tx = List.generate(32, (index) => _random.nextInt(8));
    
    appointments.add(appointment);
  }
  
  return appointments;
}

List<Expense> demoExpenses(int count) {
  final expenses = <Expense>[];
  
  // Create suppliers first (30% of entries)
  final supplierCount = (count * 0.3).round();
  final suppliers = <Expense>[];
  
  for (int i = 0; i < supplierCount; i++) {
    final supplier = Expense.fromJson({});
    supplier.isSupplier = true;
    supplier.title = _supplierNames[_random.nextInt(_supplierNames.length)];
    supplier.date = DateTime.now().subtract(Duration(days: _random.nextInt(365))).toIso8601String();
    supplier.notes = 'Trusted dental supplier';
    suppliers.add(supplier);
    expenses.add(supplier);
  }
  
  // Create orders linked to suppliers
  final orderCount = count - supplierCount;
  for (int i = 0; i < orderCount; i++) {
    final order = Expense.fromJson({});
    order.isSupplier = false;
    order.supplierID = suppliers.isNotEmpty ? suppliers[_random.nextInt(suppliers.length)].id : '';
    order.processed = _random.nextBool();
    order.cost = 10 + _random.nextDouble() * 490; // 10-500 USD
    order.date = DateTime.now().subtract(Duration(days: _random.nextInt(180))).toIso8601String();
    
    // Random items (1-5 items per order)
    final itemCount = _random.nextInt(5) + 1;
    for (int j = 0; j < itemCount; j++) {
      order.items.add(_dentalItems[_random.nextInt(_dentalItems.length)]);
    }
    
    order.title = 'Order ${i + 1}';
    order.notes = _random.nextBool() ? 'Urgent delivery needed' : '';
    expenses.add(order);
  }
  
  return expenses;
}

List<Note> demoNotes(int count) {
  final notes = <Note>[];
  
  final noteContents = [
    'Patient follow-up required next week',
    'New equipment installation scheduled',
    'Staff meeting notes - discuss new procedures',
    'Insurance claim follow-up needed',
    'Patient referral to specialist completed',
    'Inventory check completed successfully',
    'Quality assurance review notes',
    'Patient complaint resolved satisfactorily',
    'Treatment plan updated for patient',
    'Lab results received and filed'
  ];
  
  for (int i = 0; i < count; i++) {
    final note = Note.fromJson({});
    note.title = 'Note ${i + 1}';
    note.content = noteContents[_random.nextInt(noteContents.length)];
    note.date = DateTime.now().subtract(Duration(days: _random.nextInt(90))).toIso8601String();
    note.authorID = uuid(); // Would be linked to actual users
    notes.add(note);
  }
  
  return notes;
}

List<RecordModel> demoAccounts(int count) {
  final accounts = <RecordModel>[];
  
  final doctorNames = [
    'Dr. Ahmed Al-Rashid', 'Dr. Sarah Johnson', 'Dr. Mohammad Hassan',
    'Dr. Emily Chen', 'Dr. Omar Al-Zahra', 'Dr. Lisa Anderson'
  ];
  
  for (int i = 0; i < count; i++) {
    final account = RecordModel(
      id: uuid(),
      data: {
        'name': doctorNames[_random.nextInt(doctorNames.length)],
        'email': 'doctor${i + 1}@clinic.com',
        'permissions': '[2, 2, 2, 2, 2, 1, 1]', // Full permissions
        'operate': true,
        'type': 'user'
      },
    );
    accounts.add(account);
  }
  
  return accounts;
}