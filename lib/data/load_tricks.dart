import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:street_performance_helper/models/trick.dart';

class TrickRepository {
  Future<List<Trick>> getAllTricks() async {
    final db = FirebaseFirestore.instance;
    final ref = db.collection("tricks").withConverter(
          fromFirestore: Trick.fromFirestore,
          toFirestore: (e, _) => e.toFirestore(),
        );
    final docSnap = await ref.get();
    return docSnap.docs.map((e) => e.data()).toList();
  }

  Future<List<Trick>> getTricksByProp(String prop) async {
    final db = FirebaseFirestore.instance;
    final ref =
        db.collection("tricks").where("prop", isEqualTo: prop).withConverter(
              fromFirestore: Trick.fromFirestore,
              toFirestore: (e, _) => e.toFirestore(),
            );
    final docSnap = await ref.get();
    return docSnap.docs.map((e) => e.data()).toList();
  }
}
