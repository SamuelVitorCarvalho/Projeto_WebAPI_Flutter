import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/helpers/weekday.dart';
import 'package:flutter_webapi_first_course/services/journal_service.dart';
import '../../models/journal.dart';

class AddJournalScreen extends StatelessWidget {
  final Journal journal;
  final bool isEdit;
  final TextEditingController _contentController = TextEditingController();

  AddJournalScreen({required this.journal, required this.isEdit, super.key});

  @override
  Widget build(BuildContext context) {
    _contentController.text = journal.content;
    return Scaffold(
      appBar: AppBar(
        title: Text(WeekDay(journal.createdAt).toString()),
        actions: [
          IconButton(
            onPressed: () {
              registerJournal(context);
            },
            icon: Icon(Icons.check),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8, left: 8, bottom: 0, right: 8),
        child: TextField(
          controller: _contentController,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(fontSize: 24),
          expands: true,
          maxLines: null,
          minLines: null,
        ),
      ),
    );
  }

  registerJournal(BuildContext context) {
    String content = _contentController.text;
    journal.content = content;

    JournalService service = JournalService();

    if (isEdit) {
      service.register(journal).then((value) {
        Navigator.pop(context, value);
      });
    } else {
      service.edit(journal.id, journal).then((value) {
        Navigator.pop(context, value);
      });
    }
  }
}
