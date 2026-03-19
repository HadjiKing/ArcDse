import 'package:arcdse/features/appointments/appointment_model.dart';
import 'package:arcdse/services/localization/locale.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';

enum AppointmentSections {
  patient,
  doctors,
  dentalNotes,
  labworks,
  pay,
  postNotes,
  preNotes,
  prescriptions,
  appointmentNumber,
}

/// A read-only card displaying appointment details.
class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final int number;
  final bool readOnly;
  final bool showLeftBorder;
  final bool showSectionTitle;
  final int photosClipCount;
  final Color openButtonColor;
  final List<AppointmentSections> hide;

  const AppointmentCard({
    super.key,
    required this.appointment,
    this.number = 1,
    this.readOnly = false,
    this.showLeftBorder = true,
    this.showSectionTitle = true,
    this.photosClipCount = 3,
    this.openButtonColor = const Color(0xFF0078D4),
    this.hide = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: showLeftBorder
            ? Border(
                left: BorderSide(
                  color: appointment.isDone ? Colors.successPrimaryColor : Colors.warningPrimaryColor,
                  width: 3,
                ),
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!hide.contains(AppointmentSections.appointmentNumber))
            Text('#$number',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(DateFormat('d MMM yyyy').format(appointment.date)),
          if (!hide.contains(AppointmentSections.patient) &&
              appointment.patient != null)
            Text(appointment.patient!.title),
        ],
      ),
    );
  }
}
