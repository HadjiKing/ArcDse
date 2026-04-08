import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';

class TagInputItem {
  final String? value;
  final String label;
  const TagInputItem({this.value, required this.label});
}

/// A chip-based tag input widget.
class TagInputWidget extends StatefulWidget {
  final List<TagInputItem> initialValue;
  final List<TagInputItem> suggestions;
  final void Function(List<TagInputItem>) onChanged;
  final bool strict;
  final int limit;
  final String placeholder;
  final bool multiline;

  const TagInputWidget({
    super.key,
    required this.initialValue,
    required this.suggestions,
    required this.onChanged,
    this.strict = true,
    this.limit = 10,
    this.placeholder = '',
    this.multiline = false,
  });

  @override
  State<TagInputWidget> createState() => _TagInputWidgetState();
}

class _TagInputWidgetState extends State<TagInputWidget> {
  late List<TagInputItem> _tags;
  final _ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tags = List.from(widget.initialValue);
  }

  void _add(String label) {
    if (label.isEmpty) return;
    if (_tags.length >= widget.limit) return;
    final suggestion = widget.suggestions
        .where((s) => s.label.toLowerCase() == label.toLowerCase())
        .firstOrNull;
    if (widget.strict && suggestion == null) return;
    setState(() {
      _tags.add(suggestion ?? TagInputItem(value: label, label: label));
      _ctrl.clear();
    });
    widget.onChanged(_tags);
  }

  void _remove(int index) {
    setState(() => _tags.removeAt(index));
    widget.onChanged(_tags);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        ..._tags.asMap().entries.map(
              (e) => Chip(
                text: Text(e.value.label),
                onDeleted: () => _remove(e.key),
              ),
            ),
        SizedBox(
          width: 160,
          child: CupertinoTextField(
            controller: _ctrl,
            placeholder: widget.placeholder,
            onSubmitted: _add,
          ),
        ),
      ],
    );
  }
}
