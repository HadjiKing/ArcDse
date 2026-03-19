import 'package:fluent_ui/fluent_ui.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:arcdse/features/appointments/appointment_model.dart';

Future<void> printPrescription(BuildContext context, Appointment appointment) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Prescription',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Patient: ${appointment.subtitleLine1}'),
              pw.Text('Date: ${DateTime.fromMillisecondsSinceEpoch((appointment.date.millisecondsSinceEpoch / 60000).round() * 60000).toString()}'),
              pw.SizedBox(height: 20),
              pw.Text('Prescriptions:'),
              ...appointment.prescriptions.map((prescription) => 
                pw.Text('• $prescription')),
              pw.SizedBox(height: 20),
              if (appointment.notes.isNotEmpty) ...[
                pw.Text('Notes:'),
                pw.Text(appointment.notes),
              ],
            ],
          ),
        );
      },
    ),
  );

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}