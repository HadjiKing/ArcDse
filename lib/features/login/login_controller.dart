import 'package:arcdse/core/observable.dart';
import 'package:fluent_ui/fluent_ui.dart';

class _LoginController {
  final loginError = ObservableState<String?>('');
  final loadingMessage = ObservableState<String?>('');
  final isLoading = ObservableState(false);
  final proceededOffline = ObservableState(false);

  final urlField = TextEditingController();
  final emailField = TextEditingController();

  /// Shows a loading indicator with [message] while the login process is in
  /// progress.
  void loadingIndicator(String message) {
    loadingMessage(message);
    isLoading(true);
  }

  /// Marks the login process as complete and clears the loading state.
  /// Accepts an optional [error] message, which is already stored via
  /// [loginError] before this method is called.
  void finishedLoginProcess([String? error]) {
    isLoading(false);
    loadingMessage('');
  }
}

final loginCtrl = _LoginController();
