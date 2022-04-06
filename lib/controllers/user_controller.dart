import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wordly/models/user.dart';

class UserController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final firebaseInstance = FirebaseFirestore.instance;
  // Map userProfileData = {'name': '', 'email': '', 'points':0 };

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

  deleteUserDetails(String email) {
    collectionRef.where('email', isEqualTo: email).get().then((snapshot) => {
          _db.runTransaction((Transaction transaction) async {
            snapshot.docs.forEach(
                (DocumentSnapshot doc) => {transaction.delete(doc.reference)});
          })
        });
  }

  updateIsAdmin(DocumentReference docRef, bool isAdmin) {
    return docRef
        .update({'isAdmin': isAdmin})
        .then((value) => print("User was given Admin privileges"))
        .catchError((error) => print("Failed to update user to Admin: $error"));
  }

  Future checkIsAdmin(String? email) async {
    if (email == null || email == 'admin@gmail.com') return false;

    bool isAdmin = false;
    var snapshots = await collectionRef.where('email', isEqualTo: email).get();
    snapshots.docs.forEach((doc) {
      //print('$doc.data()');
      isAdmin = doc.get('isAdmin');
    });
    return isAdmin;
  }

  Future<dynamic> getUserData(String? email) async {
    QuerySnapshot snapshot = await collectionRef.where('email', isEqualTo: email).get();
    // print(snapshot.documents[0].data);
    dynamic user = snapshot.docs[0].data();
     snapshot.docs.forEach(
                (DocumentSnapshot doc) => {
                  user = doc.data()
                });
    print(user);
    // print(user['name']);
    return user;
  }

  updateUserDetails( String name, String email) async {
    try {
      _db.runTransaction((Transaction transaction) async {
        var snapshots =
            await collectionRef.where('email', isEqualTo: email).get();

        snapshots.docs.forEach((DocumentSnapshot doc) {
          doc.reference.update({'name': name});
        });

      });
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }
}
