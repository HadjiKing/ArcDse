import 'package:fluent_ui/fluent_ui.dart';
import '../features/patients/patients_store.dart';
import '../features/patients/patient_model.dart';

class PatientPicker extends StatefulWidget {
  final String? selectedPatientId;
  final ValueChanged<String?> onChanged;
  final String? label;

  const PatientPicker({
    super.key,
    this.selectedPatientId,
    required this.onChanged,
    this.label,
  });

  @override
  State<PatientPicker> createState() => _PatientPickerState();
}

class _PatientPickerState extends State<PatientPicker> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isDropdownOpen = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
        
        StreamBuilder(
          stream: patients.observableMap.stream,
          builder: (context, snapshot) {
            final allPatients = patients.observableMap.values.toList();
            final selectedPatient = allPatients
                .where((p) => p.id == widget.selectedPatientId)
                .firstOrNull;
            
            return Column(
              children: [
                // Selected patient display / search box
                TextBox(
                  controller: _searchController,
                  placeholder: selectedPatient?.name ?? 'Search patients...',
                  prefix: const Icon(FluentIcons.search),
                  suffix: selectedPatient != null
                      ? IconButton(
                          icon: const Icon(FluentIcons.clear),
                          onPressed: () {
                            widget.onChanged(null);
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                      _isDropdownOpen = value.isNotEmpty;
                    });
                  },
                  onTap: () {
                    setState(() {
                      _isDropdownOpen = true;
                    });
                  },
                ),
                
                // Dropdown list
                if (_isDropdownOpen) ...[
                  const SizedBox(height: 4),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    decoration: BoxDecoration(
                      color: FluentTheme.of(context).scaffoldBackgroundColor,
                      border: Border.all(color: Colors.grey[60]),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: _buildPatientsList(allPatients),
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildPatientsList(List<Patient> allPatients) {
    final filteredPatients = _searchQuery.isEmpty
        ? allPatients
        : allPatients.where((patient) {
            return patient.name.toLowerCase().contains(_searchQuery) ||
                   patient.phone.toLowerCase().contains(_searchQuery) ||
                   patient.email.toLowerCase().contains(_searchQuery);
          }).toList();

    if (filteredPatients.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'No patients found',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: filteredPatients.length,
      itemBuilder: (context, index) {
        final patient = filteredPatients[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: patient.color,
            radius: 16,
            child: Text(
              patient.name.isNotEmpty ? patient.name[0].toUpperCase() : '?',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          title: Text(patient.name),
          subtitle: Text(patient.phone.isNotEmpty ? patient.phone : patient.email),
          onPressed: () {
            widget.onChanged(patient.id);
            _searchController.text = patient.name;
            setState(() {
              _isDropdownOpen = false;
              _searchQuery = '';
            });
          },
        );
      },
    );
  }
}