import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wordly/models/question.dart';

class QuestionController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // get all quesions
  Stream<List<Question>> getQuesions() {
    return _db.collection('questions').snapshots().map((snapshot) => snapshot
        .docs
        .map((doc) => Question.fromJson(doc.data(), doc.reference))
        .toList());
  }

  getAllQuestions() {
    return _db.collection('questions').snapshots();
  }
}
