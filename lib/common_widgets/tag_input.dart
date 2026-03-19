import 'package:fluent_ui/fluent_ui.dart';

class TagInput extends StatefulWidget {
  final List<String> tags;
  final ValueChanged<List<String>> onChanged;
  final String? label;
  final String? placeholder;

  const TagInput({
    super.key,
    required this.tags,
    required this.onChanged,
    this.label,
    this.placeholder,
  });

  @override
  State<TagInput> createState() => _TagInputState();
}

class _TagInputState extends State<TagInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: FluentTheme.of(context).typography.body),
          const SizedBox(height: 8),
        ],
        
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[60]),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display existing tags
              if (widget.tags.isNotEmpty) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.tags.map((tag) => _TagChip(
                    tag: tag,
                    onDeleted: () => _removeTag(tag),
                  )).toList(),
                ),
                const SizedBox(height: 8),
              ],
              
              // Input field for new tags
              TextBox(
                controller: _controller,
                focusNode: _focusNode,
                placeholder: widget.placeholder ?? 'Add a tag...',
                onSubmitted: _addTag,
                suffix: IconButton(
                  icon: const Icon(FluentIcons.add),
                  onPressed: () => _addTag(_controller.text),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _addTag(String tag) {
    final trimmedTag = tag.trim();
    if (trimmedTag.isNotEmpty && !widget.tags.contains(trimmedTag)) {
      final newTags = List<String>.from(widget.tags)..add(trimmedTag);
      widget.onChanged(newTags);
      _controller.clear();
    }
    _focusNode.requestFocus();
  }

  void _removeTag(String tag) {
    final newTags = List<String>.from(widget.tags)..remove(tag);
    widget.onChanged(newTags);
  }
}

class _TagChip extends StatelessWidget {
  final String tag;
  final VoidCallback onDeleted;

  const _TagChip({
    required this.tag,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tag,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onDeleted,
            child: Icon(
              FluentIcons.clear,
              size: 12,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}