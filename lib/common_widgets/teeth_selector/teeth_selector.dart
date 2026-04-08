import 'package:arcdse/common_widgets/teeth_selector/tx_options.dart';
import 'package:fluent_ui/fluent_ui.dart';

/// Displays a dental chart where the operator can mark individual teeth.
class TeethSelector extends StatelessWidget {
  final StateType type;
  final void Function(String toothId, String? note) onNote;
  final String Function(String iso) notation;
  final String rightString;
  final String leftString;
  final Map<String, String> currentNotes;
  final Map<String, String> oldNotes;
  final bool showPrimary;

  const TeethSelector({
    super.key,
    required this.type,
    required this.onNote,
    required this.notation,
    required this.rightString,
    required this.leftString,
    required this.currentNotes,
    required this.oldNotes,
    this.showPrimary = false,
  });

  static const _upperAdult = [
    '18','17','16','15','14','13','12','11',
    '21','22','23','24','25','26','27','28',
  ];
  static const _lowerAdult = [
    '48','47','46','45','44','43','42','41',
    '31','32','33','34','35','36','37','38',
  ];
  static const _upperPrimary = [
    '55','54','53','52','51','61','62','63','64','65',
  ];
  static const _lowerPrimary = [
    '85','84','83','82','81','71','72','73','74','75',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(rightString,
                style: const TextStyle(
                    fontSize: 11, fontStyle: FontStyle.italic)),
            Text(leftString,
                style: const TextStyle(
                    fontSize: 11, fontStyle: FontStyle.italic)),
          ],
        ),
        _buildRow(_upperAdult),
        _buildRow(_lowerAdult),
        if (showPrimary) ...[
          const Divider(),
          _buildRow(_upperPrimary),
          _buildRow(_lowerPrimary),
        ],
      ],
    );
  }

  Widget _buildRow(List<String> teeth) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: teeth.map((id) {
        final hasNew = currentNotes.containsKey(id);
        final hasOld = oldNotes.containsKey(id);
        return Tooltip(
          message: hasNew
              ? currentNotes[id]!
              : hasOld
                  ? oldNotes[id]!
                  : notation(id),
          child: GestureDetector(
            onTap: () {
              if (hasNew) {
                onNote(id, null);
              } else {
                onNote(id, 'tx');
              }
            },
            child: Container(
              width: 22,
              height: 22,
              margin: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: hasNew
                    ? Colors.blue
                    : hasOld
                        ? Colors.teal.withValues(alpha: 0.4)
                        : Colors.grey.withValues(alpha: 0.15),
                border: Border.all(
                  color: Colors.grey.withValues(alpha: 0.4),
                ),
              ),
              child: Center(
                child: Text(
                  notation(id),
                  style: const TextStyle(fontSize: 7),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
