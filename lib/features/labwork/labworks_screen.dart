import 'package:fluent_ui/fluent_ui.dart';
import '../../services/localization/locale.dart';
import '../../core/multi_stream_builder.dart';
import '../../utils/iso_to_textual.dart';
import 'labworks_ctrl.dart';

class LabworksScreen extends StatelessWidget {
  const LabworksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: PageHeader(
        title: Text(txt("labworks")),
      ),
      content: MStreamBuilder(
        streams: [
          // Watch appointments store changes to update labwork list
        ],
        builder: (context, _) {
          final dueItems = labworks.due;
          final overdueItems = labworks.overdue;
          final upcomingItems = labworks.upcoming;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary Cards
                Row(
                  children: [
                    Expanded(
                      child: InfoBar(
                        title: Text(txt("overdue")),
                        content: Text('${overdueItems.length} ${txt("items")}'),
                        severity: InfoBarSeverity.error,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InfoBar(
                        title: Text(txt("upcoming")),
                        content: Text('${upcomingItems.length} ${txt("items")}'),
                        severity: InfoBarSeverity.info,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Overdue Section
                if (overdueItems.isNotEmpty) ...[
                  Text(
                    txt("overdueLabworks"),
                    style: FluentTheme.of(context).typography.subtitle,
                  ),
                  const SizedBox(height: 16),
                  ...overdueItems.map((item) => _LabworkCard(
                    item: item,
                    isOverdue: true,
                  )),
                  const SizedBox(height: 24),
                ],
                
                // Upcoming Section
                Text(
                  txt("upcomingLabworks"),
                  style: FluentTheme.of(context).typography.subtitle,
                ),
                const SizedBox(height: 16),
                
                if (upcomingItems.isEmpty)
                  Center(
                    child: Column(
                      children: [
                        const Icon(FluentIcons.manufacturing, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          txt("noLabworks"),
                          style: FluentTheme.of(context).typography.body,
                        ),
                      ],
                    ),
                  )
                else
                  ...upcomingItems.map((item) => _LabworkCard(
                    item: item,
                    isOverdue: false,
                  )),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LabworkCard extends StatelessWidget {
  final LabworkItem item;
  final bool isOverdue;

  const _LabworkCard({
    required this.item,
    required this.isOverdue,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Status indicator
            Container(
              width: 4,
              height: 60,
              decoration: BoxDecoration(
                color: isOverdue ? Colors.red : Colors.blue,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 16),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.patientName.isNotEmpty ? item.patientName : txt("unknownPatient"),
                    style: FluentTheme.of(context).typography.bodyStrong,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${txt("lab")}: ${item.labName}',
                    style: FluentTheme.of(context).typography.body,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${txt("dueDate")}: ${isoToTextual(item.dueDate.toIso8601String(), "MMM dd, yyyy")}',
                    style: FluentTheme.of(context).typography.caption?.copyWith(
                      color: isOverdue ? Colors.red : Colors.grey[100],
                    ),
                  ),
                ],
              ),
            ),
            
            // Actions
            IconButton(
              icon: const Icon(FluentIcons.completed),
              onPressed: () {
                // Mark appointment as done
                item.appointment.isDone = true;
                // Would update the appointments store here
              },
            ),
          ],
        ),
      ),
    );
  }
}