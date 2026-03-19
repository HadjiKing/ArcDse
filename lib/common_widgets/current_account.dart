import 'package:fluent_ui/fluent_ui.dart';

class CurrentAccount extends StatelessWidget {
  const CurrentAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircleAvatar(
          radius: 16,
          backgroundColor: Colors.blue,
          child: Icon(
            FluentIcons.person,
            size: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Current User', // Would be populated from login service
              style: FluentTheme.of(context).typography.bodyStrong,
            ),
            Text(
              'user@clinic.com',
              style: FluentTheme.of(context).typography.caption?.copyWith(
                color: Colors.grey[100],
              ),
            ),
          ],
        ),
      ],
    );
  }
}