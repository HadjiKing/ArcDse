import 'package:arcdse/features/appointments/open_appointment_panel.dart';
import 'package:arcdse/features/labwork/labworks_ctrl.dart';
import 'package:arcdse/features/patients/open_patient_panel.dart';
import 'package:arcdse/common_widgets/item_title.dart';
import 'package:arcdse/services/localization/locale.dart';
import 'package:arcdse/widget_keys.dart';
import 'package:fluent_ui/fluent_ui.dart';

class LabworksScreen extends StatelessWidget {
  const LabworksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final due = labworks.due;
    final notDelivered = labworks.notDelivered;
    return ScaffoldPage(
      key: WK.labworksScreen,
      content: ListView(
        children: [
          ListTile(
            title: Txt(
              "${txt("labworks")} (${txt("due")}): ${due.length}",
              style: FluentTheme.of(context).typography.subtitle,
            ),
          ),
          ...due.map(
            (e) => ListTile(
              onPressed: () => openAppointment(e),
              title: ItemTitle(item: e),
              subtitle: Txt(
                  "${DateTime.now().difference(e.date).inDays} ${txt("daysAgo")}"),
            ),
          ),
          const Divider(direction: Axis.horizontal),
          ListTile(
            title: Txt(
              "${txt("labworks")} (${txt("undelivered")}): ${notDelivered.length}",
              style: FluentTheme.of(context).typography.subtitle,
            ),
          ),
          ...notDelivered.map(
            (e) => ListTile(
              onPressed: () => openPatient(e),
              title: ItemTitle(item: e),
              subtitle: e.doneAppointments.isNotEmpty
                  ? Txt(
                      "${DateTime.now().difference(e.doneAppointments.last.date).inDays} ${txt("daysAgo")}")
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
