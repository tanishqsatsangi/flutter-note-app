import 'package:flutter/material.dart';
import 'package:notes_app_flutter/add_note.dart';
import 'package:notes_app_flutter/database_helper.dart';
import 'package:notes_app_flutter/edit_note.dart';
import 'package:notes_app_flutter/view_note.dart';

import 'note.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomeScreenState();
}



class HomeScreenState extends State<HomeScreen> {
  final  searchController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController.addListener(_onSearchChangeListener);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
        centerTitle: true,
      ),
      body: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            _navigateToAddNoteScreen(context);
          },
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 50,
              margin: EdgeInsets.all(10),
              width: double.infinity,
              child: TextFormField(
                onChanged: (text)=>_getFilteredData(text),
                controller: searchController,
                decoration: const InputDecoration(
                  labelText: "Search",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: _getFutureList(),
            ),
          ],
        ),
      ),
    );
  }

  Future _showPopupMenu(BuildContext context, Note note) {
    print("on long press");
    return showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  child: Text("Delete"),
                  onTap: () => _deleteNote(context, note),
                ),
                InkWell(
                  child: Text("Edit"),
                  onTap: () => _navigateEditNoteScreen(context, note),
                ),
              ],
            ),
          );
        });
  }

  void _deleteNote(BuildContext context, Note note) async {
    int id = await DatabaseHelper.instance.delete(note.id);

    if (id == note.id) {
      setState(() {});
    }
  }

  void _navigateToAddNoteScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => AddNoteScreen()))
        .then((value) => setState(() {}));
  }

  Widget _getListItem(Note note, BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateViewNoteScreen(context, note),
      onLongPress: () => _showPopupMenu(context, note),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          borderOnForeground: true,
          elevation: 5.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    note.data,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSearchChangeListener() {
    print("Calling search method");
     _getFilteredData(searchController.text);
  }

  Widget _getFutureList() {
    return FutureBuilder(
        future: _getData(),
        builder: (BuildContext context, AsyncSnapshot<List<Note>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  Note note = snapshot.data![index];
                  return _getListItem(note, context);
                });
          } else if (snapshot.hasError) {
            return Icon(Icons.error_outline);
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Future<List<Note>> _getData() async {
    return await DatabaseHelper.instance.queryAll();
  }
  Future<List<Note>> _getFilteredData(String data) async {
    return await DatabaseHelper.instance.searchQuery(data);
  }


  void _navigateEditNoteScreen(BuildContext context, Note note) =>
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => EditNoteScreen(note)))
          .then((value) => setState(() {}));

  void _navigateViewNoteScreen(BuildContext context, Note note) =>
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => ViewNote(note)))
          .then((value) => setState(() {}));
}
