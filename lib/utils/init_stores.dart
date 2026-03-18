import 'package:arcdse/features/appointments/appointments_store.dart';
import 'package:arcdse/features/expenses/expenses_store.dart';
import 'package:arcdse/features/notes/notes_store.dart';
import 'package:arcdse/features/patients/patients_store.dart';
import 'package:arcdse/features/settings/settings_stores.dart';

initializeStores() {
  patients.init();
  appointments.init();
  globalSettings.init();
  expenses.init();
  notes.init();
}
