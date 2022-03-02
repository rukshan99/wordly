import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wordly/widgets/main_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../controllers/user_controller.dart';
import '../models/user.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  final String appTitle = "User DB";

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final userController = UserController();
  bool isAdmin = false;

  //Functions as the controller for search field
  final TextEditingController _searchController = TextEditingController();

  //Stores the complete users list
  List<QueryDocumentSnapshot> _resultsList = [];

  //Stores the filtered users based on the search criteria
  List<QueryDocumentSnapshot> _searchResultsList = [];

  //To notify when a revert has been made for a first time deletion
  bool _isRevertDeletion = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  /// Initializes the necessary state changes needed after performing a search operation
  _onSearchChanged() {
    List<QueryDocumentSnapshot> filteredResultsList = [];
    _resultsList.forEach((element) {
      User currentUser = User.fromJson(
          element.data() as Map<String, dynamic>, element.reference);
      String formattedSearchText = _searchController.text.toLowerCase();

      if (currentUser.name.toLowerCase().contains(formattedSearchText) ||
          currentUser.email.toLowerCase().contains(formattedSearchText)) {
        filteredResultsList.add(element);
      }
    });
    setState(() {
      _searchResultsList = filteredResultsList;
    });
  }

  // Deletes the user by calling controller method delete
  _deleteUser(User userObj) {
    userController.deleteUser(userObj.email);
    _showDeleteItemToastMessage();
  }

  ///Displays a toast message after performing a successful deletion
  _showDeleteItemToastMessage() {
    Fluttertoast.showToast(
        msg: 'Selected User has been deleted !',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.red);
  }

  // Loads Delete Confirmation Dialog box
  _showDeleteAlertDialogBox(BuildContext context, User userObj) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: const Text("Continue"),
      onPressed: () {
        _deleteUser(userObj);
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Delete Confirmation "),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            const Text(
                "Are you sure you want to permanently delete this user?"),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                    flex: 1,
                    child: CupertinoButton(
                      onPressed: () => {},
                      color: Colors.amber,
                      minSize: double.minPositive,
                      padding: const EdgeInsets.fromLTRB(2, 3, 2, 3),
                      child: const Icon(Icons.lightbulb,
                          color: Colors.purple, size: 21),
                    )),
                const Flexible(
                  flex: 8,
                  child: Padding(
                      padding: EdgeInsets.all(6.0),
                      child: Text(
                          'To perform a quick deletion swipe the item horizontally by starting from either left or right.',
                          style: TextStyle(fontSize: 12, color: Colors.grey))),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // Load user profile
  _showUserProfile(BuildContext context, snapshot) {
    DocumentReference docRef = snapshot.reference;

    User userObj = User(
        name: snapshot.data()['name'],
        email: snapshot.data()['email'],
        points: snapshot.data()['points']);

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Center(
              child: SizedBox(
                width: 300,
                height: 400,
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.white70, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      const CircleAvatar(
                        backgroundImage: AssetImage('assets/img/user.png'),
                        minRadius: 60,
                        maxRadius: 100,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(userObj.name,
                          style: Theme.of(context).textTheme.headline5),
                      Text(userObj.email,
                          style: Theme.of(context).textTheme.caption),
                      const SizedBox(
                        height: 25,
                      ),
                      FlutterSwitch(
                        width: 110.0,
                        height: 45.0,
                        toggleSize: 50.0,
                        value: isAdmin,
                        borderRadius: 25.0,
                        padding: 8.0,
                        showOnOff: true,
                        activeText: 'Admin',
                        inactiveText: 'User  ',
                        onToggle: (val) {
                          setState(() {
                            isAdmin = val;
                          });
                          _updateIsAdmin(docRef, val);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  _updateIsAdmin(DocumentReference docRef, bool isAdmin) {
    userController.updateIsAdmin(docRef, isAdmin);
  }

  // Load all the users to the build body as a widget
  Widget buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: userController.getAllUsers(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
        if (snapshot.hasData) {
          // ignore: avoid_print
          print("Document -> ${snapshot.data!.docs.length}");
          _resultsList = snapshot.data!.docs;
          //Renders the user list based on the search criteria
          if (_searchController.text.isEmpty) {
            return buildList(context, _resultsList);
          } else {
            return buildList(context, _searchResultsList);
          }
        }
        return buildList(context, []);
      },
    );
  }

//Load list and convert to a list view
  Widget buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    int _currentUserNumber = 0;

    return ListView(
        children: snapshot
            .map((data) => listItemBuild(context, data, ++_currentUserNumber))
            .toList());
  }

//Load Single User Object a single item
  Widget listItemBuild(
      BuildContext context, DocumentSnapshot data, int userNumber) {
    final userObj =
        User.fromJson(data.data() as Map<String, dynamic>, data.reference);
    final String formattedUserNumberText = " " + userNumber.toString() + " ";

    return Padding(
        key: ValueKey(userObj.name),
        padding: const EdgeInsets.symmetric(vertical: 19, horizontal: 1),
        child: Dismissible(
            key: Key(userObj.email.toString() +
                Random().nextInt(10000).toString()), //--> userObj.email
            background: Container(
              color: Colors.purple,
              child: const Padding(
                padding: EdgeInsets.all(15),
                child: Icon(Icons.delete, color: Colors.red, size: 50),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(4),
              ),
              child: SingleChildScrollView(
                child: ListTile(
                  title: InkWell(
                    child: Column(children: <Widget>[
                      Row(children: <Widget>[
                        Container(
                          child: Text(formattedUserNumberText,
                              style: const TextStyle(color: Colors.white)),
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Colors.purple),
                          padding: const EdgeInsets.all(3.0),
                          margin: const EdgeInsets.only(right: 5.0),
                        ),
                        Flexible(
                            child: SubstringHighlight(
                          text: userObj.name,
                          term: _searchController.text,
                          textStyle: const TextStyle(
                              // non-highlight style
                              color: Colors.black,
                              fontSize: 16),
                          textStyleHighlight: const TextStyle(
                            // highlight style
                            color: Colors.black,
                            backgroundColor: Colors.yellow,
                          ),
                        )),
                        Container(
                            child: isAdmin
                                ? Container(
                                    child: const Text('Admin',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 2, 79, 167))),
                                    decoration: const BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                              width: 1.0,
                                              color: Color.fromARGB(
                                                  255, 2, 79, 167)),
                                          left: BorderSide(
                                              width: 1.0,
                                              color: Color.fromARGB(
                                                  255, 2, 79, 167)),
                                          right: BorderSide(
                                              width: 1.0,
                                              color: Color.fromARGB(
                                                  255, 2, 79, 167)),
                                          bottom: BorderSide(
                                              width: 1.0,
                                              color: Color.fromARGB(
                                                  255, 2, 79, 167)),
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        color:
                                            Color.fromARGB(255, 255, 255, 255)),
                                    padding: const EdgeInsets.all(3.0),
                                    margin: const EdgeInsets.only(left: 5.0),
                                  )
                                : null),
                      ]),
                      const Divider(),
                      Row(children: <Widget>[
                        Container(
                          child: const Icon(Icons.email, color: Colors.orange),
                          margin: const EdgeInsets.only(right: 3.0),
                        ),
                        Flexible(
                            child: SubstringHighlight(
                          text: userObj.email,
                          term: _searchController.text,
                          textStyle: const TextStyle(
                              // non-highlight style
                              color: Colors.black,
                              fontSize: 16),
                          textStyleHighlight: const TextStyle(
                            // highlight style
                            color: Colors.black,
                            backgroundColor: Colors.yellow,
                          ),
                        )),
                      ]),
                    ]),
                    onTap: () => {_showUserProfile(context, data)},
                  ),
                  trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _showDeleteAlertDialogBox(context, userObj);
                      }),
                ),
              ),
            ),
            onDismissed: (DismissDirection direction) {
              var value = _isFirstTimeQuickDelete();
              value.then((result) =>
                  {_performQuickDeletion(direction, result, userObj)});
            }));
  }

  ///Performs the quick deletion
  _performQuickDeletion(
    DismissDirection direction,
    bool isFirstTime,
    User user,
  ) {
    if (direction == DismissDirection.endToStart) {
      if (isFirstTime) {
        _showFirstTimeQuickDeleteAlert(context, user);
      } else {
        userController.deleteUser(user.email);
        _showDeleteItemToastMessage();
      }
    } else {
      if (isFirstTime) {
        _showFirstTimeQuickDeleteAlert(context, user);
      } else {
        userController.deleteUser(user.email);
        _showDeleteItemToastMessage();
      }
    }
  }

  ///Checks whether the Admin is attempting to use the quick deletion for the first time
  Future<bool> _isFirstTimeQuickDelete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? currentValue = prefs.getBool('isDisplayedDeleteNotification');

    if (currentValue == null || !currentValue) {
      await prefs.setBool('isDisplayedDeleteNotification', true);
      return true;
    }

    return false;
  }

  ///Loads the quick delete operation confirmation alert in the first attempt
  _showFirstTimeQuickDeleteAlert(BuildContext context, User userObj) {
    // set up the buttons
    Widget undoButton = FlatButton(
      child: const Text("Undo"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        setState(() {
          _isRevertDeletion = true;
        });
      },
    );
    Widget continueButton = FlatButton(
      child: const Text("Continue"),
      onPressed: () {
        _deleteUser(userObj);
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Alert"),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            const Text(
              'A horizontal swipe of an user will perform a quick deletion of the user, Are you sure you want to continue?',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                    flex: 1,
                    child: CupertinoButton(
                      onPressed: () => {},
                      color: Colors.amber,
                      minSize: double.minPositive,
                      padding: const EdgeInsets.fromLTRB(2, 3, 2, 3),
                      child: const Icon(Icons.lightbulb,
                          color: Colors.purple, size: 21),
                    )),
                const Flexible(
                  flex: 8,
                  child: Padding(
                      padding: EdgeInsets.all(6.0),
                      child: Text(
                          "This is only a one time alert message which appears to prevent any unnecessary deletions and won't appear in the future quick deletions",
                          style: TextStyle(fontSize: 12, color: Colors.grey))),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        undoButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

//Build Widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/img/Logo.png',
              fit: BoxFit.cover,
              height: 60.0,
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Wordly',
                style: TextStyle(fontFamily: 'Righteous', fontSize: 20.0),
              ),
            )
          ],
        ),
        backgroundColor: Colors.purple,
      ),
      drawer: const MainDrawer(),
      body: Container(
        padding: const EdgeInsets.all(19),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(),
            const SizedBox(
              height: 20,
            ),
            Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: const [
                  Icon(Icons.supervised_user_circle,
                      color: Colors.purple, size: 30),
                  Text(
                    " USERS LIST",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  )
                ]),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                  prefixIcon: const IconButton(
                    color: Colors.black,
                    icon: Icon(Icons.search),
                    iconSize: 20.0,
                    onPressed: null,
                  ),
                  suffixIcon: IconButton(
                      color: Colors.black,
                      icon: const Icon(Icons.clear),
                      iconSize: 20.0,
                      onPressed: () => _searchController.clear()),
                  contentPadding: const EdgeInsets.only(left: 25.0),
                  hintText: 'Type...',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0))),
            ),
            Flexible(child: buildBody(context))
          ],
        ),
      ),
    );
  }
}
