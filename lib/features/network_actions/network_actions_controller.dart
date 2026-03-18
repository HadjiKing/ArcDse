import 'package:arcdse/core/observable.dart';

class _NetworkActions {
  /// Tracks the number of in-flight sync operations.  The UI shows a spinner
  /// whenever this value is greater than zero.
  final isSyncing = ObservableState<int>(0);

  /// Callbacks registered by each store to trigger a manual sync.
  final syncCallbacks = <String, Function>{};

  /// Callbacks registered by each store to check whether the remote server is
  /// reachable again after a connectivity loss.
  final reconnectCallbacks = <String, Function>{};
}

final networkActions = _NetworkActions();
