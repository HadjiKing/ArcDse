import 'package:fluent_ui/fluent_ui.dart';
import '../../services/localization/locale.dart';
import '../../services/login.dart';
import '../../widget_keys.dart';
import '../../common_widgets/logo.dart';
import 'login_controller.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void dispose() {
    loginCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      key: WK.loginScreen,
      content: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppLogo(),
              const SizedBox(height: 40),
              
              // URL Field
              InfoLabel(
                label: txt("serverURL"),
                child: TextBox(
                  controller: loginCtrl.urlField,
                  placeholder: 'https://your-server.com',
                ),
              ),
              const SizedBox(height: 16),
              
              // Email Field
              InfoLabel(
                label: txt("email"),
                child: TextBox(
                  controller: loginCtrl.emailField,
                  placeholder: txt("email"),
                ),
              ),
              const SizedBox(height: 16),
              
              // Password Field
              InfoLabel(
                label: txt("password"),
                child: PasswordBox(
                  controller: loginCtrl.passwordField,
                  placeholder: txt("password"),
                ),
              ),
              const SizedBox(height: 32),
              
              // Login Button
              StreamBuilder<String>(
                stream: loginCtrl.loadingIndicator.stream,
                builder: (context, snapshot) {
                  final isLoading = (snapshot.data ?? "").isNotEmpty;
                  
                  return FilledButton(
                    onPressed: isLoading ? null : _handleLogin,
                    child: isLoading
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                width: 16,
                                height: 16,
                                child: ProgressRing(strokeWidth: 2),
                              ),
                              const SizedBox(width: 8),
                              Text(snapshot.data ?? ""),
                            ],
                          )
                        : Text(txt("login")),
                  );
                },
              ),
              const SizedBox(height: 16),
              
              // Demo Mode Button
              Button(
                onPressed: _handleDemoMode,
                child: Text(txt("demoMode")),
              ),
              
              // Error Display
              StreamBuilder<String>(
                stream: loginCtrl.loginError.stream,
                builder: (context, snapshot) {
                  final error = snapshot.data ?? "";
                  if (error.isEmpty) return const SizedBox.shrink();
                  
                  return Container(
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.red),
                    ),
                    child: Text(
                      error,
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogin() async {
    final url = loginCtrl.urlField.text.trim();
    final email = loginCtrl.emailField.text.trim();
    final password = loginCtrl.passwordField.text.trim();

    if (url.isEmpty || email.isEmpty || password.isEmpty) {
      loginCtrl.loginError(txt("fillAllFields"));
      return;
    }

    // login.activate manages loginCtrl.loadingIndicator and loginCtrl.loginError internally
    await login.activate(url, [email, password], true);
  }

  void _handleDemoMode() async {
    // login.activate manages loginCtrl.loadingIndicator and loginCtrl.loginError internally
    await login.activate("", [], false);
  }
}