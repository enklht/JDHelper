import "package:cloud_firestore/cloud_firestore.dart";

class Trick {
  String? id;
  String name;
  String prop;
  List<String> tags;
  List<Map<String, String>> performances;

  Trick({
    required this.id,
    required this.name,
    required this.prop,
    required this.tags,
    required this.performances,
  });

  factory Trick.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;
    return Trick(
      id: data["id"]?.toString(),
      name: data["name"].toString(),
      prop: data["prop"].toString(),
      tags: (data["tags"] == null)
          ? []
          : (data["tags"] as Iterable).map((e) => e.toString()).toList(),
      performances: (data["program"] == null)
          ? []
          : (data["program"] as Iterable)
              .map(
                (e) => {
                  "team": e["team"].toString(),
                  "part": e["part"].toString(),
                },
              )
              .toList(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "name": name,
    };
  }
}
