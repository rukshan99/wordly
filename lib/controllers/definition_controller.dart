// @dart=2.9

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wordly/models/definitions.dart';


class DefinitionController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create a CollectionReference that references the firestore collection
  CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('definitions');

// get all definitions
  Stream<List<Definition>> getDefinitions() {
    return _db.collection('definitions').snapshots().map((snapshot) =>
        snapshot
            .docs
            .map((doc) => Definition.fromJson(doc.data(), doc.reference))
            .toList());
  }

  getAllDefinitions() {
    return _db.collection('definitions').snapshots();
  }


//add definition , options and correct answers
  addDefinition(Definition definitionObj) async {
    try {
      _db.runTransaction((Transaction transaction) async {
        await _db.collection('definitions').doc().set(definitionObj.toMap());
      });
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  // //update definitions, options and correct answers.
  updateDefinition(Definition definitionObj, String question,
      List<String> optionsList, List<bool> answerList) {
    try {
      _db.runTransaction((transaction) async {
        await transaction.update(definitionObj.id, {
          'question': question,
          'options': optionsList,
          'answers': answerList
        });
      });
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  // // delete definition
  deleteQuestion(Definition definition) {
    _db.runTransaction((Transaction transaction) async {
      await transaction.delete(definition.id);
    });
  }


  // ///Deletes All the questions
  deleteAllQuestions(List<Definition> definitionsList) {
    _db.runTransaction((Transaction transaction) async {
      definitionsList.forEach((definition) {
        transaction.delete(definition.id);
      });
    });
  }

}