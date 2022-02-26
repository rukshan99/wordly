import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wordly/models/user.dart';

class UserController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create a CollectionReference that references the firestore collection
  CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('users');

  // Get all users
  Stream<List<User>> getUsers() {
    return _db.collection('users').snapshots().map((snapshot) => snapshot.docs
        .map((doc) => User.fromJson(doc.data(), doc.reference))
        .toList());
  }

  getAllUsers() {
    return _db.collection('users').snapshots();
  }

  // Add a user
  addUser(User userObj) async {
    try {
      _db.runTransaction((Transaction transaction) async {
        await _db.collection('users').doc().set(userObj.toMap());
      });
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  // Delete a user
  // --> need to handle the deleted user from firebase auth
  deleteUser(String email) {
    collectionRef.where('email', isEqualTo: email).get().then((snapshot) => {
          _db.runTransaction((Transaction transaction) async {
            snapshot.docs.forEach(
                (DocumentSnapshot doc) => {transaction.delete(doc.reference)});
          })
        });
  }
}
