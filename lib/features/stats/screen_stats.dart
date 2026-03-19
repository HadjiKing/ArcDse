import 'package:fluent_ui/fluent_ui.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/localization/locale.dart';
import '../../core/multi_stream_builder.dart';
import '../appointments/appointments_store.dart';
import '../patients/patients_store.dart';
import 'charts_controller.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: PageHeader(
        title: Text(txt("statistics")),
        commandBar: CommandBar(
          primaryItems: [
            CommandBarButton(
              icon: const Icon(FluentIcons.refresh),
              label: Text(txt("refresh")),
              onPressed: () {
                chartsCtrl.resetSelected();
                appointments.synchronize();
                patients.synchronize();
              },
            ),
          ],
        ),
      ),
      content: MStreamBuilder(
        streams: [
          appointments.observableMap.stream,
          patients.observableMap.stream,
          chartsCtrl.filterByOperatorID.stream,
        ],
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary Cards
                Row(
                  children: [
                    Expanded(child: _SummaryCard(
                      title: txt("totalPatients"),
                      value: patients.observableMap.values.length.toString(),
                      icon: FluentIcons.people,
                      color: Colors.blue,
                    )),
                    const SizedBox(width: 16),
                    Expanded(child: _SummaryCard(
                      title: txt("totalAppointments"),
                      value: appointments.observableMap.values.length.toString(),
                      icon: FluentIcons.calendar,
                      color: Colors.green,
                    )),
                    const SizedBox(width: 16),
                    Expanded(child: _SummaryCard(
                      title: txt("totalRevenue"),
                      value: _calculateTotalRevenue(),
                      icon: FluentIcons.money,
                      color: Colors.orange,
                    )),
                  ],
                ),
                const SizedBox(height: 32),
                
                // Charts Section
                Text(
                  txt("monthlyRevenue"),
                  style: FluentTheme.of(context).typography.subtitle,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 300,
                  child: _RevenueChart(),
                ),
                const SizedBox(height: 32),
                
                Text(
                  txt("appointmentStatus"),
                  style: FluentTheme.of(context).typography.subtitle,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 300,
                  child: _AppointmentStatusChart(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _calculateTotalRevenue() {
    final total = appointments.observableMap.values
        .where((appointment) => appointment.isDone)
        .fold(0.0, (sum, appointment) => sum + appointment.paid);
    return '\$${total.toStringAsFixed(2)}';
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const Spacer(),
                Text(
                  value,
                  style: FluentTheme.of(context).typography.title?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: FluentTheme.of(context).typography.body?.copyWith(
                color: Colors.grey[100],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RevenueChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appointmentsList = appointments.observableMap.values.toList();
    final monthlyData = <String, double>{};
    
    // Group appointments by month and sum revenue
    for (final appointment in appointmentsList) {
      if (!appointment.isDone) continue;
      
      final monthKey = '${appointment.date.year}-${appointment.date.month.toString().padLeft(2, '0')}';
      monthlyData[monthKey] = (monthlyData[monthKey] ?? 0) + appointment.paid;
    }
    
    final sortedEntries = monthlyData.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              getTitlesWidget: (value, meta) => Text('\$${value.toInt()}'),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < sortedEntries.length) {
                  return Text(sortedEntries[index].key.substring(5));
                }
                return const Text('');
              },
            ),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: sortedEntries.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value.value);
            }).toList(),
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            dotData: const FlDotData(show: true),
          ),
        ],
      ),
    );
  }
}

class _AppointmentStatusChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appointmentsList = appointments.observableMap.values.toList();
    final doneCount = appointmentsList.where((a) => a.isDone).length;
    final pendingCount = appointmentsList.length - doneCount;
    
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: doneCount.toDouble(),
            title: '${txt("completed")}\n$doneCount',
            color: Colors.green,
            radius: 100,
          ),
          PieChartSectionData(
            value: pendingCount.toDouble(),
            title: '${txt("pending")}\n$pendingCount',
            color: Colors.orange,
            radius: 100,
          ),
        ],
        centerSpaceRadius: 40,
      ),
    );
  }
}