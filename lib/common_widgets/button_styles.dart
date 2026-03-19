import 'package:fluent_ui/fluent_ui.dart';

class ButtonContent extends StatelessWidget {
  final IconData icon;
  final String text;

  const ButtonContent(this.icon, this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}

// Re-export FluentIcons as WindowsIcons for compatibility
class WindowsIcons {
  static const IconData add = FluentIcons.add;
  static const IconData edit = FluentIcons.edit;
  static const IconData delete = FluentIcons.delete;
  static const IconData save = FluentIcons.save;
  static const IconData cancel = FluentIcons.cancel;
  static const IconData search = FluentIcons.search;
  static const IconData filter = FluentIcons.filter;
  static const IconData refresh = FluentIcons.refresh;
  static const IconData settings = FluentIcons.settings;
  static const IconData home = FluentIcons.home;
  static const IconData back = FluentIcons.back;
  static const IconData forward = FluentIcons.forward;
  static const IconData up = FluentIcons.up;
  static const IconData down = FluentIcons.down;
  static const IconData left = FluentIcons.left;
  static const IconData right = FluentIcons.right;
  static const IconData close = FluentIcons.close;
  static const IconData minimize = FluentIcons.minimize;
  static const IconData maximize = FluentIcons.maximize;
  static const IconData people = FluentIcons.people;
  static const IconData person = FluentIcons.person;
  static const IconData calendar = FluentIcons.calendar;
  static const IconData clock = FluentIcons.clock;
  static const IconData mail = FluentIcons.mail;
  static const IconData phone = FluentIcons.phone;
  static const IconData folder = FluentIcons.folder;
  static const IconData folder_open = FluentIcons.folder_open;
  static const IconData document = FluentIcons.document;
  static const IconData print = FluentIcons.print;
  static const IconData copy = FluentIcons.copy;
  static const IconData cut = FluentIcons.cut;
  static const IconData paste = FluentIcons.paste;
  static const IconData undo = FluentIcons.undo;
  static const IconData redo = FluentIcons.redo;
  static const IconData bold = FluentIcons.bold;
  static const IconData italic = FluentIcons.italic;
  static const IconData underline = FluentIcons.underline;
  static const IconData quick_note = FluentIcons.sticky_notes;
  static const IconData note = FluentIcons.sticky_notes;
}