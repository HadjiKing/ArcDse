import 'package:fluent_ui/fluent_ui.dart';
import '../features/appointments/appointment_model.dart';
import '../utils/iso_to_textual.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final VoidCallback? onTap;
  final bool showPatient;

  const AppointmentCard({
    super.key,
    required this.appointment,
    this.onTap,
    this.showPatient = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: appointment.color,
          child: Icon(
            appointment.isDone ? FluentIcons.completed : FluentIcons.calendar,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          showPatient && appointment.subtitleLine1.isNotEmpty
              ? appointment.subtitleLine1
              : appointment.title,
          style: FluentTheme.of(context).typography.bodyStrong,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isoToTextual(appointment.date.toIso8601String(), 'MMM dd, yyyy HH:mm')),
            if (appointment.subtitleLine2.isNotEmpty)
              Text(
                appointment.subtitleLine2,
                style: FluentTheme.of(context).typography.caption,
              ),
            if (appointment.price > 0)
              Text(
                '\$${appointment.price.toStringAsFixed(2)}',
                style: FluentTheme.of(context).typography.caption?.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (appointment.hasLabwork)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue),
                ),
                child: Text(
                  'LAB',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: appointment.isDone 
                    ? Colors.green.withOpacity(0.1) 
                    : Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: appointment.isDone ? Colors.green : Colors.orange,
                ),
              ),
              child: Text(
                appointment.isDone ? 'Done' : 'Pending',
                style: TextStyle(
                  color: appointment.isDone ? Colors.green : Colors.orange,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        onPressed: onTap,
      ),
    );
  }
}