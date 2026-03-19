import 'package:fluent_ui/fluent_ui.dart';

/// Centralised repository of [Key]s used across the widget tree.
/// Having all keys in one place makes it easy to reference them in tests and
/// in code that needs to find a specific widget.
class WK {
  WK._();

  static const fluentApp = Key('fluent_app');
  static const builder = Key('builder');
  static const backButton = Key('back_button');
  static const globalActions = Key('global_actions');
  static const loginScreen = Key('login_screen');
  static const dashboardScreen = Key('dashboard_screen');
  static const expensesScreen = Key('expenses_screen');
  static const calendarScreen = Key('calendar_screen');
  static const patientsScreen = Key('patients_screen');
  static const settingsScreen = Key('settings_screen');
  static const accountsScreen = Key('accounts_screen');
  static const notesScreen = Key('notes_screen');
  static const labworksScreen = Key('labworks_screen');
  static const statsScreen = Key('stats_screen');
}
