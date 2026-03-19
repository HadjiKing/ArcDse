import 'package:fluent_ui/fluent_ui.dart';

class DateTimePicker extends StatefulWidget {
  final DateTime? value;
  final ValueChanged<DateTime>? onChanged;
  final String? label;
  final bool showTime;

  const DateTimePicker({
    super.key,
    this.value,
    this.onChanged,
    this.label,
    this.showTime = false,
  });

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  late DateTime _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.value ?? DateTime.now();
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
        
        Row(
          children: [
            Expanded(
              child: Button(
                child: Row(
                  children: [
                    const Icon(FluentIcons.calendar),
                    const SizedBox(width: 8),
                    Text(_formatDate(_selectedDateTime)),
                  ],
                ),
                onPressed: () => _showDatePicker(context),
              ),
            ),
            
            if (widget.showTime) ...[
              const SizedBox(width: 8),
              Expanded(
                child: Button(
                  child: Row(
                    children: [
                      const Icon(FluentIcons.clock),
                      const SizedBox(width: 8),
                      Text(_formatTime(_selectedDateTime)),
                    ],
                  ),
                  onPressed: () => _showTimePicker(context),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final result = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    
    if (result != null) {
      setState(() {
        _selectedDateTime = DateTime(
          result.year,
          result.month,
          result.day,
          _selectedDateTime.hour,
          _selectedDateTime.minute,
        );
      });
      widget.onChanged?.call(_selectedDateTime);
    }
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final result = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    
    if (result != null) {
      setState(() {
        _selectedDateTime = DateTime(
          _selectedDateTime.year,
          _selectedDateTime.month,
          _selectedDateTime.day,
          result.hour,
          result.minute,
        );
      });
      widget.onChanged?.call(_selectedDateTime);
    }
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}