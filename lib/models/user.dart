import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name;
  final String email;
  final int points;

  DocumentReference id;

  User({
    required this.name,
    required this.email,
    required this.id,
    required this.points,
  });

  factory User.fromJson(Map<String, dynamic> json, DocumentReference docRef) {
    // ignore: avoid_print
    print(json['user']);
    return User(
        id: docRef,
        name: json['question'] as String,
        email: json['question'] as String,
        points: json['points'] as int);
  }

  Map<String, dynamic> toMap() {
    return {"name": name, "email": email, "points": points, "id": id};
  }
}
