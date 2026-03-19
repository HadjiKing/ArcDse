import 'package:fluent_ui/fluent_ui.dart';

class OperatorsPicker extends StatefulWidget {
  final List<String> selectedOperators;
  final ValueChanged<List<String>> onChanged;
  final List<String> availableOperators; // Would be populated from accounts store

  const OperatorsPicker({
    super.key,
    required this.selectedOperators,
    required this.onChanged,
    this.availableOperators = const [],
  });

  @override
  State<OperatorsPicker> createState() => _OperatorsPickerState();
}

class _OperatorsPickerState extends State<OperatorsPicker> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Operators',
          style: FluentTheme.of(context).typography.bodyStrong,
        ),
        const SizedBox(height: 8),
        
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[60]),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: [
              // Mock operators since we don't have the accounts store populated
              ...['Dr. Smith', 'Dr. Johnson', 'Dr. Brown'].map((operator) {
                final isSelected = widget.selectedOperators.contains(operator);
                return CheckboxListTile(
                  title: Text(operator),
                  value: isSelected,
                  onChanged: (bool? value) {
                    final newSelection = List<String>.from(widget.selectedOperators);
                    if (value == true) {
                      newSelection.add(operator);
                    } else {
                      newSelection.remove(operator);
                    }
                    widget.onChanged(newSelection);
                  },
                );
              }),
              
              if (widget.availableOperators.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'No operators available',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}