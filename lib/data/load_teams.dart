import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:street_performance_helper/models/team.dart';

class TeamRepository {
  Future<List<Team>> getAllTeams() async {
    final db = FirebaseFirestore.instance;
    final ref = db.collection("teams").withConverter(
          fromFirestore: Team.fromFirestore,
          toFirestore: (e, _) => e.toFirestore(),
        );
    final docSnap = await ref.get();
    return docSnap.docs.map((e) => e.data()).toList()
      ..sort(
        (a, b) {
          final int cmp = b.year.compareTo(a.year);
          if (cmp == 0) {
            return a.pronunciation.compareTo(b.pronunciation);
          }
          return cmp;
        },
      );
  }
}
