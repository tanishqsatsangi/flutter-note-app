import 'package:flutter/material.dart';
import 'package:notes_app_flutter/note.dart';

import 'database_helper.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({Key? key}) : super(key: key);

  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

final TextEditingController titleEditController = TextEditingController();
final TextEditingController textEditingController = TextEditingController();

class _AddNoteScreenState extends State<AddNoteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: _navigateToHomeScreen, icon: Icon(Icons.arrow_back)),
        title: Text("Add Note"),
        actions: [
          IconButton(
            onPressed: () {
              _saveNote();
            },
            icon: Icon(
              Icons.check,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: titleEditController,
                  decoration: const InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  minLines: 5,
                  controller: textEditingController,
                  maxLines: 9223372036854775807,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveNote() async {
    print(DatabaseHelper.instance.queryAll());
    String title = titleEditController.text;
    String text = textEditingController.text;
    if (title.isEmpty && text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter some data"),
        ),
      );
    } else {
      Note note = Note(id: 0, title: title, data: text);
      int id = await DatabaseHelper.instance.insert(note.toMap());
      _navigateToHomeScreen();
    }
  }

  void _navigateToHomeScreen() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    titleEditController.clear();
    textEditingController.clear();
  }
}
