import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wordly/models/review.dart';

class ReviewController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('reviews');


    // Add a review
  addReview(Review reviewObj) async {
    try {
      _db.runTransaction((Transaction transaction) async {
        await _db.collection('reviews').doc().set(reviewObj.toMap());
      });
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  // Get all reviews
  Stream<List<Review>> getReviews(String email) {
    return _db.collection('reviews').snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Review.fromJson(doc.data(), doc.reference))
        .toList());
  }

  getAllReviews() {
    return _db.collection('reviews').snapshots();
  }

 

}