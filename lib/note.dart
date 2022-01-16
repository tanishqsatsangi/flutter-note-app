final String tableNotes = 'notesa';

class NoteFields {
  static final String id = 'id';
  static final String title = 'title';
  static final String data = 'data';
}

class Note {
  final int id;
  final String title;
  final String data;

  Note({required this.id, required this.title, required this.data});

  factory Note.fromMap(Map<String, dynamic> map) => Note(
        id: map['id'],
        title: map['title'],
        data: map['data'],
      );

  Map<String, dynamic> toMap() {
    Map<String,dynamic> map=Map();
    map['title']=title;
    map['data']=data;
    if(id!=null){
      map['id']=id;
    }
    return map;
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'Note( title:$title, data:$data)';
  }

  Map<String, Object?> toJson() => {
        NoteFields.id: id,
        NoteFields.title: title,
        NoteFields.data: data,
      };
}
