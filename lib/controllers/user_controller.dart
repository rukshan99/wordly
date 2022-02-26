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
  deleteUser(DocumentReference user) {
    _db.runTransaction((Transaction transaction) async {
      await transaction.delete(user);
    });
  }
}
