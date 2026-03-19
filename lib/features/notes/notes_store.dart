import '../../core/store.dart';
import '../../core/save_local.dart';
import '../../core/save_remote.dart';
import '../../services/login.dart';
import '../../utils/demo_generator.dart';
import 'notes_model.dart';

class Notes extends Store<Note> {
  Notes() : super(
    modeling: (json) => Note.fromJson(json),
    local: SaveLocal("notes"),
    remote: login.isDemo ? null : SaveRemote("notes"),
    isDemo: login.isDemo,
  );

  @override
  void init() {
    super.init();
    
    // Load demo data if in demo mode
    if (login.isDemo) {
      Future.delayed(const Duration(milliseconds: 100), () {
        final demoData = demoNotes(20);
        observableMap.setAll(demoData);
      });
    }
  }

  Future<void> addNote(String content, String authorID) async {
    final note = Note.fromJson({});
    note.title = content.length > 30 ? '${content.substring(0, 30)}...' : content;
    note.content = content;
    note.date = DateTime.now().toIso8601String();
    note.authorID = authorID;
    
    observableMap.set(note);
  }

  List<Note> get allNotes => observableMap.values;

  List<Note> get recentNotes {
    final notes = allNotes;
    notes.sort((a, b) => b.date.compareTo(a.date));
    return notes.take(10).toList();
  }

  Note? getById(String id) => observableMap.get(id);

  void deleteNote(String id) {
    observableMap.remove(id);
  }

  Future<void> updateNote(String id, String content) async {
    final note = getById(id);
    if (note != null) {
      note.content = content;
      note.title = content.length > 30 ? '${content.substring(0, 30)}...' : content;
      note.date = DateTime.now().toIso8601String();
      observableMap.set(note);
    }
  }
}

final notes = Notes();