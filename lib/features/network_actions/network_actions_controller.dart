import '../../core/observable.dart';

class _NetworkActions {
  final isSyncing = ObservableState(0);
  
  // Callbacks for sync operations
  final Map<String, Future<void> Function()> syncCallbacks = {};
  final Map<String, Future<void> Function()> reconnectCallbacks = {};
  
  Future<void> resync() async {
    if (isSyncing() > 0) return; // Already syncing
    
    isSyncing(syncCallbacks.length);
    
    try {
      // Execute all sync callbacks
      final futures = syncCallbacks.values.map((callback) => callback());
      await Future.wait(futures);
    } catch (e) {
      // Handle sync errors
    } finally {
      isSyncing(0);
    }
  }
  
  Future<void> reconnect() async {
    try {
      // Execute all reconnect callbacks
      final futures = reconnectCallbacks.values.map((callback) => callback());
      await Future.wait(futures);
    } catch (e) {
      // Handle reconnection errors
    }
  }
  
  void registerSyncCallback(String name, Future<void> Function() callback) {
    syncCallbacks[name] = callback;
  }
  
  void registerReconnectCallback(String name, Future<void> Function() callback) {
    reconnectCallbacks[name] = callback;
  }
  
  void dispose() {
    isSyncing.dispose();
    syncCallbacks.clear();
    reconnectCallbacks.clear();
  }
}

final networkActions = _NetworkActions();