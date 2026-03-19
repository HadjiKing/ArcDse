import 'package:fluent_ui/fluent_ui.dart';

class DialogWithTextBox extends StatefulWidget {
  final String title;
  final String placeholder;
  final String? initialValue;
  final ValueChanged<String> onConfirm;

  const DialogWithTextBox({
    super.key,
    required this.title,
    required this.placeholder,
    this.initialValue,
    required this.onConfirm,
  });

  @override
  State<DialogWithTextBox> createState() => _DialogWithTextBoxState();
}

class _DialogWithTextBoxState extends State<DialogWithTextBox> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Text(widget.title),
      content: TextBox(
        controller: _controller,
        placeholder: widget.placeholder,
        autofocus: true,
      ),
      actions: [
        Button(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        FilledButton(
          child: const Text('OK'),
          onPressed: () {
            widget.onConfirm(_controller.text);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}