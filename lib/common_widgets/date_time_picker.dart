import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

/// A button-activated date (and optionally time) picker.
class DateTimePicker extends StatefulWidget {
  final DateTime initValue;
  final void Function(DateTime) onChange;
  final String buttonText;
  final IconData buttonIcon;
  final String format;
  final bool pickTime;

  const DateTimePicker({
    super.key,
    required this.initValue,
    required this.onChange,
    required this.buttonText,
    required this.buttonIcon,
    this.format = 'd MMMM yyyy',
    this.pickTime = false,
  });

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  late DateTime _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initValue;
  }

  Future<void> _pick(BuildContext context) async {
    if (widget.pickTime) {
      final time = await showCupertinoModalPopup<DateTime>(
        context: context,
        builder: (context) {
          DateTime tmp = _selected;
          return Container(
            height: 220,
            color: FluentTheme.of(context).menuColor,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              initialDateTime: _selected,
              onDateTimeChanged: (d) => tmp = d,
            ),
          );
        },
      );
      if (time != null && mounted) {
        setState(() => _selected = time);
        widget.onChange(time);
      }
    } else {
      final date = await showCupertinoModalPopup<DateTime>(
        context: context,
        builder: (context) {
          DateTime tmp = _selected;
          return Container(
            height: 220,
            color: FluentTheme.of(context).menuColor,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: _selected,
              onDateTimeChanged: (d) => tmp = d,
            ),
          );
        },
      );
      if (date != null && mounted) {
        setState(() => _selected = date);
        widget.onChange(date);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: () => _pick(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(widget.buttonIcon),
          const SizedBox(width: 6),
          Text(DateFormat(widget.format).format(_selected)),
        ],
      ),
    );
  }
}
