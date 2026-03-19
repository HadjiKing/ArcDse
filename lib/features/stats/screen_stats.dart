import 'package:arcdse/features/accounts/accounts_controller.dart';
import 'package:arcdse/features/appointments/appointments_store.dart';
import 'package:arcdse/features/stats/charts_controller.dart';
import 'package:arcdse/services/localization/locale.dart';
import 'package:arcdse/services/login.dart';
import 'package:arcdse/utils/constants.dart';
import 'package:arcdse/widget_keys.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  int _year = DateTime.now().year;
  int _month = DateTime.now().month;

  Map<int, double> _buildMonthlyRevenue() {
    final result = <int, double>{};
    for (var i = 1; i <= 12; i++) {
      result[i] = 0;
    }
    for (final a in appointments.filtered.values) {
      if (a.date.year == _year && a.isDone) {
        result[a.date.month] = (result[a.date.month] ?? 0) + a.paid;
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final monthly = _buildMonthlyRevenue();
    final total =
        monthly.values.fold(0.0, (sum, v) => sum + v);

    return ScaffoldPage(
      key: WK.statsScreen,
      content: StreamBuilder(
        stream: chartsCtrl.filterByOperatorID.stream,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Filter bar
              Row(
                children: [
                  ComboBox<int>(
                    value: _year,
                    items: List.generate(5, (i) => DateTime.now().year - i)
                        .map((y) =>
                            ComboBoxItem<int>(value: y, child: Text('$y')))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => _year = v);
                    },
                  ),
                  const SizedBox(width: 8),
                  if (login.permissions[PInt.stats] == 2)
                    ComboBox<String>(
                      value: chartsCtrl.filterByOperatorID(),
                      items: [
                        ComboBoxItem<String>(
                            value: '', child: Text(txt("allDoctors"))),
                        ...accounts.operators.map(
                          (op) => ComboBoxItem<String>(
                              value: op.id, child: Text(accounts.name(op))),
                        ),
                      ],
                      onChanged: (v) {
                        chartsCtrl.filterByOperatorID(v ?? '');
                        appointments.filterByOperatorID(v ?? '');
                        setState(() {});
                      },
                    ),
                ],
              ),
              const SizedBox(height: 16),
              // Summary tiles
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _SummaryTile(
                    label: txt("totalRevenue"),
                    value: total.toStringAsFixed(2),
                    icon: FluentIcons.money,
                    color: Colors.teal,
                  ),
                  _SummaryTile(
                    label: txt("completedAppointments"),
                    value: appointments.filtered.values
                        .where((a) =>
                            a.isDone && a.date.year == _year)
                        .length
                        .toString(),
                    icon: FluentIcons.calendar,
                    color: Colors.blue,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Monthly breakdown
              ...List.generate(12, (i) {
                final month = i + 1;
                final value = monthly[month] ?? 0;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 90,
                        child: Text(
                          DateFormat('MMMM').format(DateTime(_year, month)),
                          style: FluentTheme.of(context).typography.caption,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 20,
                          color: Colors.blue.withValues(alpha: 0.15),
                          child: FractionallySizedBox(
                            widthFactor:
                                total > 0 ? (value / total).clamp(0, 1) : 0,
                            alignment: Alignment.centerLeft,
                            child: Container(color: Colors.blue),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 70,
                        child: Text(
                          value.toStringAsFixed(0),
                          textAlign: TextAlign.right,
                          style: FluentTheme.of(context).typography.caption,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final AccentColor color;

  const _SummaryTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: FluentTheme.of(context)
                    .typography
                    .subtitle!
                    .copyWith(color: color.dark),
              ),
              Text(
                label,
                style: FluentTheme.of(context).typography.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
