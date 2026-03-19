import 'package:fluent_ui/fluent_ui.dart';

class FirstLaunchDialog extends StatelessWidget {
  const FirstLaunchDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text('Welcome to ArcDSE'),
      content: const SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to ArcDSE Dental Clinic Management Software!',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'This is your first time using the application. Here are some quick tips to get you started:',
            ),
            SizedBox(height: 16),
            Text('• Add patients from the Patients section'),
            Text('• Schedule appointments using the Calendar'),
            Text('• Track expenses in the Expenses section'),
            Text('• View statistics and reports in Stats'),
            Text('• Manage clinic settings from the Settings menu'),
            SizedBox(height: 16),
            Text(
              'You can access this information anytime from the Help menu.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
      actions: [
        FilledButton(
          child: const Text('Get Started'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}