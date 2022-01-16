import 'package:flutter/material.dart';
import 'package:notes_app_flutter/database_helper.dart';
import 'package:notes_app_flutter/note.dart';

class TestDB extends StatelessWidget {
  const TestDB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  Note note = Note(id:0,title: "title", data: "data");
                  int i = await DatabaseHelper.instance.insert(note.toMap());
                  print("i  in insert $i");
                },
                child: Text("Insert"),
              ),
              ElevatedButton(
                onPressed: () async {
                  Note note = Note(id:0,title: "title update", data: "data update");
                  int i = await DatabaseHelper.instance.update(note.toMap());
                  print("i  in update $i");
                },
                child: Text("Update"),
              ),
              ElevatedButton(
                onPressed: () async {
                  int i = await DatabaseHelper.instance.delete(1);
                  print("i  in delete $i");
                },
                child: Text("Delete"),
              ),
              ElevatedButton(
                onPressed: () async {
                  List<Note> querys =
                      await DatabaseHelper.instance.queryAll();
                  print("query in $querys");
                },
                child: Text("Read All"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
