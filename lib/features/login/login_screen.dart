import 'package:arcdse/core/multi_stream_builder.dart';
import 'package:arcdse/features/login/login_controller.dart';
import 'package:arcdse/services/launch.dart';
import 'package:arcdse/services/localization/locale.dart';
import 'package:arcdse/services/login.dart';
import 'package:arcdse/services/network.dart';
import 'package:arcdse/widget_keys.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      key: WK.loginScreen,
      content: Center(
        child: SizedBox(
          width: 360,
          child: MStreamBuilder(
            streams: [
              loginCtrl.isLoading.stream,
              loginCtrl.loginError.stream,
              loginCtrl.loadingMessage.stream,
            ],
            builder: (context, _) {
              if (loginCtrl.isLoading()) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const ProgressRing(),
                    const SizedBox(height: 16),
                    Text(loginCtrl.loadingMessage() ?? ''),
                  ],
                );
              }
              return _LoginForm(context);
            },
          ),
        ),
      ),
    );
  }

  Widget _LoginForm(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'ArcDse',
          textAlign: TextAlign.center,
          style: FluentTheme.of(context).typography.title,
        ),
        const SizedBox(height: 24),
        InfoLabel(
          label: txt("serverUrl"),
          child: CupertinoTextField(
            controller: loginCtrl.urlField,
            placeholder: 'https://your-server.com',
            keyboardType: TextInputType.url,
          ),
        ),
        const SizedBox(height: 12),
        InfoLabel(
          label: txt("email"),
          child: CupertinoTextField(
            controller: loginCtrl.emailField,
            placeholder: 'admin@example.com',
            keyboardType: TextInputType.emailAddress,
          ),
        ),
        const SizedBox(height: 12),
        InfoLabel(
          label: txt("password"),
          child: _PasswordField(),
        ),
        const SizedBox(height: 20),
        if (loginCtrl.loginError()?.isNotEmpty == true)
          InfoBar(
            title: Text(loginCtrl.loginError()!),
            severity: InfoBarSeverity.error,
          ),
        const SizedBox(height: 10),
        FilledButton(
          onPressed: () => login.activate(
            loginCtrl.urlField.text,
            [loginCtrl.emailField.text, _passwordController.text],
            network.isOnline(),
          ),
          child: Text(txt("login")),
        ),
        if (network.isOnline() == false) ...[
          const SizedBox(height: 8),
          Button(
            onPressed: () => login.activate(
              loginCtrl.urlField.text,
              [login.token],
              false,
            ),
            child: Text(txt("continueOffline")),
          ),
        ],
        if (launch.isDemo) ...[
          const SizedBox(height: 8),
          Button(
            onPressed: () => login.activate('demo', [], false),
            child: Text(txt("tryDemo")),
          ),
        ],
      ],
    );
  }
}

final _passwordController = TextEditingController();

class _PasswordField extends StatefulWidget {
  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CupertinoTextField(
            controller: _passwordController,
            obscureText: _obscure,
            placeholder: '••••••',
          ),
        ),
        IconButton(
          icon: Icon(_obscure ? FluentIcons.hide3 : FluentIcons.view),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
      ],
    );
  }
}
