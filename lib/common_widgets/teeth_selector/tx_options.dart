import 'package:fluent_ui/fluent_ui.dart';

class TxOptions extends StatelessWidget {
  final int selectedTreatment;
  final ValueChanged<int> onChanged;

  const TxOptions({
    super.key,
    required this.selectedTreatment,
    required this.onChanged,
  });

  static const List<TreatmentOption> treatmentOptions = [
    TreatmentOption(value: 0, label: 'Healthy', color: Colors.white),
    TreatmentOption(value: 1, label: 'Caries', color: Colors.yellow),
    TreatmentOption(value: 2, label: 'Extraction Needed', color: Colors.red),
    TreatmentOption(value: 3, label: 'Crown', color: Colors.blue),
    TreatmentOption(value: 4, label: 'Filling', color: Colors.green),
    TreatmentOption(value: 5, label: 'Root Canal', color: Colors.purple),
    TreatmentOption(value: 6, label: 'Cleaning Needed', color: Colors.orange),
    TreatmentOption(value: 7, label: 'Implant', color: Colors.teal),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: treatmentOptions.map((option) {
        final isSelected = selectedTreatment == option.value;
        
        return GestureDetector(
          onTap: () => onChanged(option.value),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? option.color : option.color.withOpacity(0.2),
              border: Border.all(
                color: option.color,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: option.color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey[100]),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  option.label,
                  style: TextStyle(
                    color: isSelected && option.value > 0 ? Colors.white : Colors.black,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class TreatmentOption {
  final int value;
  final String label;
  final Color color;

  const TreatmentOption({
    required this.value,
    required this.label,
    required this.color,
  });
}