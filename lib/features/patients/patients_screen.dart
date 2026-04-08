import 'package:arcdse/common_widgets/archive_toggle.dart';
import 'package:arcdse/common_widgets/item_title.dart';
import 'package:arcdse/common_widgets/tag_input.dart';
import 'package:arcdse/core/multi_stream_builder.dart';
import 'package:arcdse/features/patients/open_patient_panel.dart';
import 'package:arcdse/features/patients/patients_store.dart';
import 'package:arcdse/services/archived.dart';
import 'package:arcdse/services/localization/locale.dart';
import 'package:arcdse/services/login.dart';
import 'package:arcdse/utils/constants.dart';
import 'package:arcdse/widget_keys.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  String _search = '';
  String _tagFilter = '';

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      key: WK.patientsScreen,
      padding: EdgeInsets.zero,
      content: Column(
        children: [
          _buildCommandBar(),
          Expanded(
            child: MStreamBuilder(
              streams: [patients.observableMap.stream, showArchived.stream],
              builder: (context, _) => _buildList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommandBar() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: const Offset(0.0, 6.0),
            blurRadius: 30.0,
            spreadRadius: 5.0,
            color: Colors.grey.withAlpha(50),
          )
        ],
        color: FluentTheme.of(context).menuColor,
      ),
      child: Row(
        children: [
          if (login.permissions[PInt.patients] != 1)
            IconButton(
              onPressed: () => openPatient(),
              icon: Row(
                children: [
                  const Icon(FluentIcons.add_friend, size: 17),
                  const SizedBox(width: 8),
                  Txt(txt("addPatient")),
                ],
              ),
            ),
          const SizedBox(width: 8),
          Expanded(
            child: CupertinoTextField(
              placeholder: txt("search"),
              onChanged: (v) => setState(() => _search = v.toLowerCase()),
            ),
          ),
          const SizedBox(width: 8),
          if (patients.allTags.isNotEmpty)
            ComboBox<String>(
              value: _tagFilter.isEmpty ? null : _tagFilter,
              placeholder: Text(txt("filterByTag")),
              items: [
                ComboBoxItem<String>(value: '', child: Text(txt("allTags"))),
                ...patients.allTags.map(
                  (t) => ComboBoxItem<String>(value: t, child: Text(t)),
                ),
              ],
              onChanged: (v) => setState(() => _tagFilter = v ?? ''),
            ),
          const SizedBox(width: 8),
          const ArchiveToggle(),
        ],
      ),
    );
  }

  Widget _buildList() {
    final items = patients.present.values.where((p) {
      final matchSearch =
          _search.isEmpty || p.title.toLowerCase().contains(_search);
      final matchTag =
          _tagFilter.isEmpty || p.tags.contains(_tagFilter);
      return matchSearch && matchTag;
    }).toList()
      ..sort((a, b) => a.title.compareTo(b.title));

    if (items.isEmpty) {
      return Center(child: Txt(txt("noResultsFound")));
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, i) {
        final patient = items[i];
        return ListTile(
          onPressed: () => openPatient(patient),
          leading: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: patient.color,
            ),
            child: Center(
              child: Text(
                patient.title.isNotEmpty ? patient.title[0].toUpperCase() : '?',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          title: ItemTitle(item: patient),
          subtitle: patient.tags.isNotEmpty
              ? Wrap(
                  spacing: 4,
                  children: patient.tags
                      .map((t) => Chip(
                            text: Text(t),
                          ))
                      .toList(),
                )
              : null,
          trailing: patient.phone.isNotEmpty ? Text(patient.phone) : null,
        );
      },
    );
  }
}
