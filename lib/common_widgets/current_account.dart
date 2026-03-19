import 'package:arcdse/features/accounts/accounts_controller.dart';
import 'package:arcdse/services/login.dart';
import 'package:fluent_ui/fluent_ui.dart';

/// Shows the current logged-in account name below the app logo.
class CurrentAccount extends StatelessWidget {
  const CurrentAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Center(
        child: Text(
          accounts.list().isEmpty ? '' : accounts.nameOrEmailFromID(login.currentAccountID),
          style: FluentTheme.of(context).typography.caption,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
