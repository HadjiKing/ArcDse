import 'package:arcdse/core/model.dart';
import 'package:fluent_ui/fluent_ui.dart';

/// Displays the [Model.title] with an optional coloured leading avatar.
class ItemTitle extends StatelessWidget {
  final Model item;
  const ItemTitle({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: item.color,
          ),
        ),
        const SizedBox(width: 6),
        Flexible(child: Text(item.title, overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}
