import 'package:fluent_ui/fluent_ui.dart';
import '../../services/localization/locale.dart';
import '../../core/multi_stream_builder.dart';
import '../../widget_keys.dart';
import 'patients_store.dart';
import 'open_patient_panel.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      key: WK.patientsScreen,
      header: PageHeader(
        title: Text(txt("patients")),
        commandBar: CommandBar(
          primaryItems: [
            CommandBarButton(
              icon: const Icon(FluentIcons.add),
              label: Text(txt("addPatient")),
              onPressed: () => openPatient(null),
            ),
          ],
        ),
      ),
      content: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            child: TextBox(
              controller: _searchController,
              placeholder: txt("searchPatients"),
              prefix: const Icon(FluentIcons.search),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          
          // Patients List
          Expanded(
            child: MStreamBuilder(
              streams: [patients.observableMap.stream],
              builder: (context, _) {
                final allPatients = patients.observableMap.values.toList();
                
                // Filter patients based on search query
                final filteredPatients = _searchQuery.isEmpty
                    ? allPatients
                    : allPatients.where((patient) {
                        return patient.name.toLowerCase().contains(_searchQuery) ||
                               patient.phone.toLowerCase().contains(_searchQuery) ||
                               patient.email.toLowerCase().contains(_searchQuery);
                      }).toList();
                
                // Sort by name
                filteredPatients.sort((a, b) => a.name.compareTo(b.name));
                
                if (filteredPatients.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _searchQuery.isEmpty ? FluentIcons.people : FluentIcons.search,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty ? txt("noPatients") : txt("noPatientsFound"),
                          style: FluentTheme.of(context).typography.subtitle,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredPatients.length,
                  itemBuilder: (context, index) {
                    final patient = filteredPatients[index];
                    return _PatientCard(
                      patient: patient,
                      onTap: () => openPatient(patient),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PatientCard extends StatelessWidget {
  final patient;
  final VoidCallback onTap;

  const _PatientCard({
    required this.patient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: patient.color,
          child: Text(
            patient.name.isNotEmpty ? patient.name[0].toUpperCase() : '?',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          patient.name,
          style: FluentTheme.of(context).typography.bodyStrong,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (patient.subtitleLine1.isNotEmpty)
              Text(patient.subtitleLine1),
            if (patient.subtitleLine2.isNotEmpty)
              Text(
                patient.subtitleLine2,
                style: FluentTheme.of(context).typography.caption?.copyWith(
                  color: Colors.grey[100],
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (patient.tags.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue),
                ),
                child: Text(
                  patient.tags.first,
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            const Icon(FluentIcons.chevron_right),
          ],
        ),
        onPressed: onTap,
      ),
    );
  }
}