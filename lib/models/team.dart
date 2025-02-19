import 'package:cloud_firestore/cloud_firestore.dart';

class Team {
  String id;
  String name;
  String pronunciation;
  int? year;
  int? memberNum;
  String? kind;
  String? theme;
  String? characters;
  String? note;
  String? youtubeId;
  List<Map<String, String>>? program;

  Team({
    required this.id,
    required this.name,
    required this.pronunciation,
    this.year,
    this.memberNum,
    this.kind,
    this.theme,
    this.characters,
    this.note,
    this.youtubeId,
    this.program,
  });

  factory Team.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;
    return Team(
      id: data["id"].toString(),
      name: data["name"].toString(),
      pronunciation: data["pronunciation"].toString(),
      year: int.tryParse(data["year"].toString()),
      memberNum: int.tryParse(data["memberNum"].toString()),
      kind: data["kind"].toString(),
      theme: data["theme"].toString(),
      characters: data["characters"].toString(),
      note: data["note"].toString(),
      youtubeId: data["youtubeId"].toString(),
      program: data["program"] is Iterable
          ? (data["program"] as Iterable).map((e) {
              return {
                "part": e["part"].toString(),
                "prop": e["prop"].toString(),
              };
            }).toList()
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "name": name,
      "pronunciation": pronunciation,
      if (year != null) "year": year,
      if (memberNum != null) "memberNum": memberNum,
    };
  }
}
