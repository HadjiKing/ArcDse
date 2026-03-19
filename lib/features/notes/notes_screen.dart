import 'package:arcdse/app/routes.dart';
import 'package:arcdse/common_widgets/archive_toggle.dart';
import 'package:arcdse/common_widgets/button_styles.dart';
import 'package:arcdse/common_widgets/dialogs/dialog_with_text_box.dart';
import 'package:arcdse/common_widgets/item_title.dart';
import 'package:arcdse/common_widgets/tag_input.dart';
import 'package:arcdse/core/multi_stream_builder.dart';
import 'package:arcdse/features/notes/notes_model.dart';
import 'package:arcdse/features/notes/notes_store.dart';
import 'package:arcdse/features/patients/open_patient_panel.dart';
import 'package:arcdse/features/patients/patients_store.dart';
import 'package:arcdse/services/archived.dart';
import 'package:arcdse/services/localization/locale.dart';
import 'package:arcdse/services/login.dart';
import 'package:arcdse/widget_keys.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      key: WK.notesScreen,
      padding: EdgeInsets.zero,
      content: Column(
        children: [
          _buildCommandBar(),
          Expanded(
            child: MStreamBuilder(
              streams: [notes.observableMap.stream, showArchived.stream],
              builder: (context, _) => _buildNotesList(),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => DialogWithTextBox(
                  title: txt("addNote"),
                  onSave: (content) {
                    notes.set(Note.fromJson({
                      'content': content,
                      'operatorID': login.currentAccountID,
                    }));
                  },
                  icon: FluentIcons.quick_note,
                ),
              );
            },
            icon: Row(
              children: [
                const Icon(FluentIcons.add, size: 17),
                const SizedBox(width: 8),
                Txt(txt("addNote")),
              ],
            ),
          ),
          const ArchiveToggle(),
        ],
      ),
    );
  }

  Widget _buildNotesList() {
    final items = notes.present.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    if (items.isEmpty) {
      return Center(child: Txt(txt("noResultsFound")));
    }
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, i) {
        final note = items[i];
        final patient =
            note.patientID.isNotEmpty ? patients.get(note.patientID) : null;
        return ListTile(
          title: Text(note.content),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(DateFormat('d MMM yyyy').format(note.date)),
              if (patient != null)
                HyperlinkButton(
                  onPressed: () => openPatient(patient),
                  child: ItemTitle(item: patient),
                ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(FluentIcons.delete),
            onPressed: () =>
                notes.set(note..archived = !(note.archived ?? false)),
          ),
        );
      },
    );
  }
}
