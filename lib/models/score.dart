// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';

class Score {
  final String name;
  final String email;
  final int points;
  final DateTime createdAt;

  Score({
    this.name,
    this.email,
    this.points,
    this.createdAt,
  });

  factory Score.fromJson(Map<String, dynamic> json, DocumentReference docRef) {
    // ignore: avoid_print
    print(json['score']);
    return Score(
      name: json['name'] as String,
      email: json['email'] as String,
      points: json['points'] as int,
      createdAt: json['createdAt'] as DateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "points": points,
      "createdAt": createdAt,
      
    };
  }
}
