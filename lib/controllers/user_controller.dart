import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wordly/models/user.dart';

class UserController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get all users
  Stream<List<User>> getUsers() {
    return _db.collection('users').snapshots().map((snapshot) => snapshot.docs
        .map((doc) => User.fromJson(doc.data(), doc.reference))
        .toList());
  }

  getAllUsers() {
    return _db.collection('users').snapshots();
  }

}
