import 'package:arcdse/services/localization/locale.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';

/// A simple dialog with a text input and a save button.
class DialogWithTextBox extends StatefulWidget {
  final String title;
  final void Function(String value) onSave;
  final IconData icon;

  const DialogWithTextBox({
    super.key,
    required this.title,
    required this.onSave,
    required this.icon,
  });

  @override
  State<DialogWithTextBox> createState() => _DialogWithTextBoxState();
}

class _DialogWithTextBoxState extends State<DialogWithTextBox> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Row(
        children: [
          Icon(widget.icon),
          const SizedBox(width: 8),
          Text(widget.title),
        ],
      ),
      content: CupertinoTextField(controller: _ctrl),
      actions: [
        FilledButton(
          onPressed: () {
            if (_ctrl.text.isNotEmpty) {
              widget.onSave(_ctrl.text);
              Navigator.of(context).pop();
            }
          },
          child: Text(txt("save")),
        ),
        Button(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(txt("cancel")),
        ),
      ],
    );
  }
}
