import 'package:arcdse/core/observable.dart';
import 'package:arcdse/features/appointments/appointments_store.dart';

/// Controller for the statistics / charts screen.
///
/// Exposes filters and a reset helper that are called from [routes].
class _ChartsController {
  /// Currently selected operator ID filter (empty = show all).
  final filterByOperatorID = ObservableState<String>('');

  /// Reset any current chart selection (e.g. when navigating away).
  void resetSelected() {
    filterByOperatorID('');
    appointments.filterByOperatorID('');
  }
}

final chartsCtrl = _ChartsController();
