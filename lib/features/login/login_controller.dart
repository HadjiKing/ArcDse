import 'package:fluent_ui/fluent_ui.dart';
import '../../core/observable.dart';

class _LoginController {
  final loadingIndicator = ObservableState("");
  final loginError = ObservableState("");
  final proceededOffline = ObservableState(false);
  
  final urlField = TextEditingController();
  final emailField = TextEditingController();
  final passwordField = TextEditingController();
  
  bool loginInProgress = false;
  
  void finishedLoginProcess([String error = ""]) {
    loginInProgress = false;
    loadingIndicator("");
    if (error.isNotEmpty) {
      loginError(error);
    } else {
      loginError("");
    }
  }
  
  void startLoginProcess([String message = "Logging in..."]) {
    loginInProgress = true;
    loadingIndicator(message);
    loginError("");
  }
  
  void dispose() {
    urlField.dispose();
    emailField.dispose();
    passwordField.dispose();
    loadingIndicator.dispose();
    loginError.dispose();
    proceededOffline.dispose();
  }
}

final loginCtrl = _LoginController();