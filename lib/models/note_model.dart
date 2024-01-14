class NoteModel {
  String title;
  String desc;

  NoteModel({
    required this.title,
    required this.desc,
  });

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "desc": desc,
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      title: map["title"],
      desc: map["desc"],
    );
  }
}
