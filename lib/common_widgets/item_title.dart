import 'package:fluent_ui/fluent_ui.dart';
import '../core/model.dart';

class ItemTitle extends StatelessWidget {
  final Model item;
  final TextStyle? style;

  const ItemTitle({
    super.key,
    required this.item,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: item.color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            item.title,
            style: style ?? FluentTheme.of(context).typography.body,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}