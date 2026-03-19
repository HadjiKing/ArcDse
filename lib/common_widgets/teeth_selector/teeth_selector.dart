import 'package:fluent_ui/fluent_ui.dart';
import 'tx_options.dart';

class TeethSelector extends StatefulWidget {
  final List<int> treatments; // 32 teeth x treatments
  final ValueChanged<List<int>> onChanged;

  const TeethSelector({
    super.key,
    required this.treatments,
    required this.onChanged,
  });

  @override
  State<TeethSelector> createState() => _TeethSelectorState();
}

class _TeethSelectorState extends State<TeethSelector> {
  int _selectedTooth = -1;
  late List<int> _treatments;

  @override
  void initState() {
    super.initState();
    _treatments = List<int>.from(widget.treatments);
    // Ensure we have 32 teeth
    while (_treatments.length < 32) {
      _treatments.add(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dental Chart',
          style: FluentTheme.of(context).typography.bodyStrong,
        ),
        const SizedBox(height: 16),
        
        // Upper jaw
        Text('Upper Jaw', style: FluentTheme.of(context).typography.body),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Upper right (teeth 1-8)
            ...List.generate(8, (index) => _buildTooth(index)),
            const SizedBox(width: 16),
            // Upper left (teeth 9-16)
            ...List.generate(8, (index) => _buildTooth(index + 8)),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Lower jaw
        Text('Lower Jaw', style: FluentTheme.of(context).typography.body),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lower right (teeth 17-24)
            ...List.generate(8, (index) => _buildTooth(index + 16)),
            const SizedBox(width: 16),
            // Lower left (teeth 25-32)
            ...List.generate(8, (index) => _buildTooth(index + 24)),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Treatment options
        if (_selectedTooth >= 0) ...[
          Text(
            'Treatment for Tooth ${_selectedTooth + 1}',
            style: FluentTheme.of(context).typography.bodyStrong,
          ),
          const SizedBox(height: 8),
          TxOptions(
            selectedTreatment: _treatments[_selectedTooth],
            onChanged: (treatment) {
              setState(() {
                _treatments[_selectedTooth] = treatment;
              });
              widget.onChanged(_treatments);
            },
          ),
        ],
      ],
    );
  }

  Widget _buildTooth(int toothIndex) {
    final isSelected = _selectedTooth == toothIndex;
    final treatment = _treatments[toothIndex];
    final hasCondition = treatment > 0;
    
    return Container(
      margin: const EdgeInsets.all(2),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTooth = isSelected ? -1 : toothIndex;
          });
        },
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: hasCondition 
                ? _getTreatmentColor(treatment)
                : Colors.white,
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.grey,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              '${toothIndex + 1}',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: hasCondition ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getTreatmentColor(int treatment) {
    switch (treatment) {
      case 1: return Colors.yellow; // Caries
      case 2: return Colors.red; // Extraction needed
      case 3: return Colors.blue; // Crown
      case 4: return Colors.green; // Filling
      case 5: return Colors.purple; // Root canal
      case 6: return Colors.orange; // Cleaning needed
      case 7: return Colors.teal; // Implant
      default: return Colors.grey;
    }
  }
}