class NoteModel {
  String title;
  String desc;
  String time;

  NoteModel({
    required this.title,
    required this.desc,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "desc": desc,
      "time": time,
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      title: map["title"],
      desc: map["desc"],
      time: map["time"],
    );
  }
}
