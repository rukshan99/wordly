import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wordly/models/score.dart';
import 'package:wordly/models/question.dart';

class ScoreController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create a CollectionReference that references the firestore collection
  CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('scores');

  CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

  // get all quesions
  Stream<List<Question>> getQuesions() {
    return _db.collection('definitions').snapshots().map((snapshot) => snapshot
        .docs
        .map((doc) => Question.fromJson(doc.data(), doc.reference))
        .toList());
  }

  getAllQuestions() {
    return _db.collection('definitions').snapshots();
  }

  // Get all scores
  Stream<List<Score>> getScores() {
    return _db
        .collection('scores')
        .orderBy('points', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Score.fromJson(doc.data(), doc.reference))
            .toList());
  }

  getAllScores() {
    return _db.collection('scores').snapshots();
  }

  // Add a Score
  addScore(Score userObj) async {
    try {
      _db.runTransaction((Transaction transaction) async {
        await _db.collection('scores').doc().set(userObj.toMap());
      });
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  //update score
  updateScore(Score userObj) async {
    try {
      _db.runTransaction((Transaction transaction) async {
        var snapshots =
            await usersRef.where('email', isEqualTo: userObj.email).get();

        snapshots.docs.forEach((DocumentSnapshot doc) {
          doc.reference.update({'points': FieldValue.increment(userObj.points)});
        });

        // await _db
        //     .collection('users')
        //     .doc(doc)
        //     .update({'points': userObj.points});
      });
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }
}
