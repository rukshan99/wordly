import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name;
  final String email;
  final int points;
  final bool isAdmin;

  User({
    required this.name,
    required this.email,
    required this.points,
    required this.isAdmin
  });

  factory User.fromJson(Map<String, dynamic> json, DocumentReference docRef) {
    // ignore: avoid_print
    print(json['user']);
    return User(
        name: json['name'] as String,
        email: json['email'] as String,
        points: json['points'] as int,
        isAdmin: json['isAdmin'] as bool);
  }

  Map<String, dynamic> toMap() {
    return {"name": name, "email": email, "points": points, "isAdmin": isAdmin};
  }
}
