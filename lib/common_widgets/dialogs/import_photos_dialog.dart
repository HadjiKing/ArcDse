import 'package:arcdse/app/routes.dart';
import 'package:arcdse/features/appointments/appointment_model.dart';
import 'package:arcdse/features/appointments/appointments_store.dart';
import 'package:arcdse/services/localization/locale.dart';
import 'package:arcdse/utils/imgs.dart';
import 'package:arcdse/utils/logger.dart';
import 'dart:convert' show json;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';

/// Dialog that lets the user paste an image URL to import into an appointment.
class ImportDialog extends StatefulWidget {
  final Panel<Appointment> panel;
  const ImportDialog({super.key, required this.panel});

  @override
  State<ImportDialog> createState() => _ImportDialogState();
}

class _ImportDialogState extends State<ImportDialog> {
  final _ctrl = TextEditingController();
  bool _loading = false;
  String _error = '';

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _import() async {
    final url = _ctrl.text.trim();
    if (url.isEmpty) return;
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      final imgName = await handleNewImageFromUrl(
        rowID: widget.panel.item.id,
        url: url,
      );
      if (!widget.panel.item.imgs.contains(imgName)) {
        widget.panel.item.imgs.add(imgName);
        appointments.set(widget.panel.item);
        widget.panel.savedJson = json.encode(widget.panel.item.toJson());
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e, s) {
      logger('Error importing image: $e', s);
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Text(txt("importPhoto")),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CupertinoTextField(
            controller: _ctrl,
            placeholder: 'https://...',
          ),
          if (_error.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(_error, style: const TextStyle(color: Colors.errorPrimaryColor)),
            ),
        ],
      ),
      actions: [
        if (_loading)
          const Center(child: ProgressRing())
        else ...[
          FilledButton(onPressed: _import, child: Text(txt("import"))),
          Button(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(txt("cancel")),
          ),
        ],
      ],
    );
  }
}
