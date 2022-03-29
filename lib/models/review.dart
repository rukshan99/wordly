import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String email;
  final double ratingValue;
  final String comment;
  

  Review({
    required this.email,
    required this.ratingValue,
    required this.comment
  });

  factory Review.fromJson(Map<String, dynamic> json, DocumentReference docRef) {
    // ignore: avoid_print
    print(json['review']);
    return Review(
        email: json['email'] as String,
        ratingValue: json['ratingValue'] as double,
        comment: json['comment'] as String);
  }

  Map<String, dynamic> toMap() {
    return {"email": email,"ratingValue": ratingValue, "comment": comment};
  }
}