// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';

class Definition {
  final String question;
  final List<String> options;
  final List<bool> answers;
  final DateTime createdDateTime;

  DocumentReference id; 
      //Definition(question: "", options: <String>[], answers: <bool>[])
          //as DocumentReference<Definition>;

  Definition(
      {this.question,
      this.options,
      this.answers,
      this.id,
      this.createdDateTime});

  factory Definition.fromJson(
      Map<String, dynamic> json, DocumentReference docRef) {
    print(json['question']);
    Timestamp createdTimeStamp = json['createdDateTime'];
    return Definition(
      id: docRef,
      question: json['question'] as String,
      options: List<String>.from(json['options'].map((x) => x)),
      answers: List<bool>.from(json['answers'].map((x) => x)),
      createdDateTime:
          createdTimeStamp != null ? createdTimeStamp.toDate() : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "createdDateTime": createdDateTime,
      "question": question,
      "options": options,
      "answers": answers,
      "id": id
    };
  }
}
