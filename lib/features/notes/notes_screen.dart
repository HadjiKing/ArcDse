import 'package:fluent_ui/fluent_ui.dart';
import '../../services/localization/locale.dart';
import '../../core/multi_stream_builder.dart';
import 'notes_store.dart';
import 'notes_model.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: PageHeader(
        title: Text(txt("notes")),
        commandBar: CommandBar(
          primaryItems: [
            CommandBarButton(
              icon: const Icon(FluentIcons.add),
              label: Text(txt("addNote")),
              onPressed: () => _showAddNoteDialog(context),
            ),
          ],
        ),
      ),
      content: MStreamBuilder(
        streams: [notes.observableMap.stream],
        builder: (context, _) {
          final allNotes = notes.allNotes;
          
          if (allNotes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(FluentIcons.note, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    txt("noNotes"),
                    style: FluentTheme.of(context).typography.subtitle,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: allNotes.length,
            itemBuilder: (context, index) {
              final note = allNotes[index];
              return _NoteCard(note: note);
            },
          );
        },
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context) {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => ContentDialog(
        title: Text(txt("addNote")),
        content: TextBox(
          controller: controller,
          placeholder: txt("noteContent"),
          maxLines: 5,
        ),
        actions: [
          Button(
            child: Text(txt("cancel")),
            onPressed: () => Navigator.of(context).pop(),
          ),
          FilledButton(
            child: Text(txt("add")),
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                notes.addNote(controller.text.trim(), "current_user"); // Would use actual user ID
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final Note note;

  const _NoteCard({required this.note});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    style: FluentTheme.of(context).typography.bodyStrong,
                  ),
                  const SizedBox(height: 8),
                  Text(note.content),
                  const SizedBox(height: 8),
                  Text(
                    note.date,
                    style: FluentTheme.of(context).typography.caption?.copyWith(
                      color: Colors.grey[100],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(FluentIcons.delete),
              onPressed: () => notes.deleteNote(note.id),
            ),
          ],
        ),
      ),
    );
  }
}