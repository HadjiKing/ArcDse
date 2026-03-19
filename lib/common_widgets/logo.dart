import 'package:fluent_ui/fluent_ui.dart';

class AppLogo extends StatelessWidget {
  final double? size;

  const AppLogo({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size ?? 64,
          height: size ?? 64,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue,
                Colors.blue.darker,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            FluentIcons.health,
            color: Colors.white,
            size: (size ?? 64) * 0.5,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'ArcDSE',
          style: FluentTheme.of(context).typography.title?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Dental Clinic Management',
          style: FluentTheme.of(context).typography.caption?.copyWith(
            color: Colors.grey[100],
          ),
        ),
      ],
    );
  }
}