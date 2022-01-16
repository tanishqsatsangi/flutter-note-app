import 'package:flutter/material.dart';
import 'package:notes_app_flutter/edit_note.dart';

import 'database_helper.dart';
import 'note.dart';

class ViewNote extends StatefulWidget {
  Note note;

  ViewNote(this.note);

  @override
  _ViewNoteState createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              _navigateToAddNoteScreen(context, widget.note);
            },
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              _confirmDialog(context, widget.note);
            },
            icon: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  widget.note.title,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  widget.note.data,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToAddNoteScreen(BuildContext context, Note note) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => EditNoteScreen(note)))
        .then((value) async {
      widget.note = await DatabaseHelper.instance.singleNote(widget.note.id);
      setState(() {});
    });
  }

  void _deleteNote(BuildContext context, Note note) async {
    int id = await DatabaseHelper.instance.delete(note.id);
    print("Delete ${id}");
    if (id == note.id) {
      Navigator.of(context).canPop() ? Navigator.of(context).pop() : "";
    }
  }

  _confirmDialog(BuildContext context, Note note) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Do you want to Delete this Note"),
            actions: [
              ElevatedButton(
                onPressed: () => _deleteNote(context, note),
                child: Text("DELETE"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("CANCEL"),
              ),
            ],
          );
        });
  }
}
