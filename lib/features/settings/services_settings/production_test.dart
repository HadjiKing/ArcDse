import 'package:arcdse/features/appointments/appointments_store.dart';
import 'package:arcdse/features/patients/patients_store.dart';
import 'package:arcdse/services/localization/locale.dart';
import 'package:arcdse/services/network.dart';
import 'package:fluent_ui/fluent_ui.dart';

/// A diagnostics widget for verifying that the production data stores are
/// operating correctly. Visible to admins in the Settings screen.
class ProductionTests extends StatelessWidget {
  const ProductionTests({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          txt("diagnostics"),
          style: FluentTheme.of(context).typography.bodyStrong,
        ),
        const SizedBox(height: 8),
        _buildRow(
          context,
          txt("online"),
          network.isOnline(),
        ),
        _buildRow(
          context,
          txt("patients"),
          patients.docs.isNotEmpty,
          extra: '${patients.docs.length}',
        ),
        _buildRow(
          context,
          txt("appointments"),
          appointments.docs.isNotEmpty,
          extra: '${appointments.docs.length}',
        ),
      ],
    );
  }

  Widget _buildRow(BuildContext context, String label, bool ok,
      {String extra = ''}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(
            ok ? FluentIcons.skype_check : FluentIcons.warning,
            color: ok ? Colors.successPrimaryColor : Colors.warningPrimaryColor,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(label),
          if (extra.isNotEmpty) ...[
            const SizedBox(width: 4),
            Text('($extra)',
                style: FluentTheme.of(context).typography.caption),
          ],
        ],
      ),
    );
  }
}
