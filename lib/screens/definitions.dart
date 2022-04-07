// @dart=2.9
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wordly/widgets/main_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:substring_highlight/substring_highlight.dart';

import '../controllers/definition_controller.dart';
import '../models/definitions.dart';

class definitionList  extends StatefulWidget {
  definitionList() : super();

  final String appTitle = "Definition DB";

  @override
  _DefinitionListState  createState() => _DefinitionListState();
}

class _DefinitionListState extends State<definitionList> {
  final definitionController  = DefinitionController();

  //Functions as the controller for search field
  TextEditingController _searchController = TextEditingController();

  //Stores the complete questions list
  List<QueryDocumentSnapshot> _resultsList = [];

  //Stores the filtered questions based on the search criteria
  List<QueryDocumentSnapshot> _searchResultsList = [];

  //To notify when a revert has been made for a first time deletion
  bool _isRevertDeletion = false;

//Initialize Text Fields
  TextEditingController questionController = TextEditingController();
  TextEditingController optionController1 = TextEditingController();
  TextEditingController optionController2 = TextEditingController();
  TextEditingController optionController3 = TextEditingController();
  TextEditingController optionController4 = TextEditingController();

//Intialize the Check Box boolean values
  bool option1 = false;
  bool option2 = false;
  bool option3 = false;
  bool option4 = false;

//initialze the Update indication boolean variable
  bool isEditing = false;

//initialize the current qustion object
  Definition currentQuestion;

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
      Definition currentQuestion =
          Definition.fromJson(element.data(), element.reference);
      String formattedSearchText = _searchController.text.toLowerCase();

      if (currentQuestion.question
              .toLowerCase()
              .contains(formattedSearchText) ||
          currentQuestion.options
              .elementAt(0)
              .toLowerCase()
              .contains(formattedSearchText) ||
          currentQuestion.options
              .elementAt(1)
              .toLowerCase()
              .contains(formattedSearchText) ||
          currentQuestion.options
              .elementAt(2)
              .toLowerCase()
              .contains(formattedSearchText) ||
          currentQuestion.options
              .elementAt(3)
              .toLowerCase()
              .contains(formattedSearchText)) {
        filteredResultsList.add(element);
      }
    });
    setState(() {
      _searchResultsList = filteredResultsList;
    });
  }

  //Call the add question method in the controller
  addQuestion() {
    List<String> optionsList = [
      optionController1.text,
      optionController2.text,
      optionController3.text,
      optionController4.text
    ];
    List<bool> answerList = [option1, option2, option3, option4];
    var createdDateTime = new DateTime.now();
    Definition questionObj = Definition(
        question: questionController.text,
        options: optionsList,
        answers: answerList,
        createdDateTime: createdDateTime);

    definitionController.addDefinition(questionObj);

    Fluttertoast.showToast(
        msg: 'New Question has been added !',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.green);
  }

//Call the Update Question in the method in the controller
  updateQuestion() {
    List<String> newOptionsList = [
      optionController1.text,
      optionController2.text,
      optionController3.text,
      optionController4.text
    ];
    List<bool> newAnswerList = [option1, option2, option3, option4];

    if (isEditing) {
      definitionController.updateDefinition(currentQuestion, questionController.text,
          newOptionsList, newAnswerList);
      setState(() {
        isEditing = false;
      });
    }

    Fluttertoast.showToast(
        msg: 'Selected Question has been updated !',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.blue);
  }

//load the Update View UI
  setUpdateUI(Definition questionObj) {
    viewAddUpdateDialogBox(context);
    questionController.text = questionObj.question;
    optionController1.text = questionObj.options[0];
    optionController2.text = questionObj.options[1];
    optionController3.text = questionObj.options[2];
    optionController4.text = questionObj.options[3];

    option1 = questionObj.answers[0];
    option2 = questionObj.answers[1];
    option3 = questionObj.answers[2];
    option4 = questionObj.answers[3];

    setState(() {
      isEditing = true;
      currentQuestion = questionObj;
    });
  }

  ///Deletes the question by calling controller method delete
  _deleteQuestion(Definition questionObj) {
    definitionController.deleteQuestion(questionObj);
    _showDeleteItemToastMessage();
  }

  ///Displays a toast message after performing a successful deletion
  _showDeleteItemToastMessage() {
    Fluttertoast.showToast(
        msg: 'Selected Question has been deleted !',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.red);
  }

  ///Displays a toast message after performing a successful delete all
  _showDeleteAllToastMessage() {
    Fluttertoast.showToast(
        msg: 'All the Questions have been deleted !',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.red);
  }

//Reinitilaze the State
  reinitializeState() {
    setState(() {
      isEditing = false;

      questionController.text = "";
      optionController1.text = "";
      optionController2.text = "";
      optionController3.text = "";
      optionController4.text = "";

      option1 = false;
      option2 = false;
      option3 = false;
      option4 = false;
    });
  }

//Load the Form validations as Pop-ups
  showValidationDialog(BuildContext context, String msg) {
    // set up the button
    Widget okButton = FlatButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.red.shade100,
      title: const Text("Validation Alert"),
      content: Text(msg),
      actions: [
        okButton,
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

//Loads Delete Confirmation Dialog box
  _showDeleteAlertDialogBox(BuildContext context, Definition questionObj) {
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
        _deleteQuestion(questionObj);
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Delete Confirmation "),
//      content: Text(
//          "Are you sure you want to permanently delete this question from the list?"),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            const Text(
                "Are you sure you want to permanently delete this question from the list?"),
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
                      child:
                          const Icon(Icons.lightbulb, color: Color.fromARGB(255, 32,167,219), size: 21),
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

  //Loads Delete All Confirmation Dialog box
  _showDeleteAllAlertDialogBox(BuildContext context) {
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
        _deleteAllQuestions();
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Delete Confirmation "),
      content: const Text(
          "Are you sure you want to permanently delete all the questions in the list??"),
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

// Load the Add and Update Forms as a dialog box
  viewAddUpdateDialogBox(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text(isEditing ? "UPDATE DEFINITION" : "ADD NEW DEFINITION",
                  textAlign: TextAlign.center),
              backgroundColor: Colors.blue.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(45),
              ),
              elevation: 0,
              content: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Positioned(
                    right: -40,
                    top: -80,
                    child: InkResponse(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const CircleAvatar(
                        child: Icon(Icons.close),
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ),
                  Form(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: questionController,
                              decoration: const InputDecoration(
                                  labelText: "Definition",
                                  hintText: "Enter Definition"),
                            ),
                          ),
                          const Divider(
                            color: Color.fromARGB(255, 32,167,219),
                            thickness: 5.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: optionController1,
                              decoration: const InputDecoration(
                                  labelText: "Option 1",
                                  hintText: "Enter Option 1"),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CheckboxListTile(
                              title: const Text("Option 1 is Correct!"),
                              value: option1,
                              onChanged: (bool value) {
                                setState(() {
                                  option1 = value;
                                });
                              },
                            ),
                          ),
                          const Divider(
                            color: Color.fromARGB(255, 32,167,219),
                            thickness: 5.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: optionController2,
                              decoration: const InputDecoration(
                                  labelText: "Option 2",
                                  hintText: "Enter Option 2"),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CheckboxListTile(
                              title: const Text("Option 2 is Correct!"),
                              value: option2,
                              onChanged: (bool value) {
                                setState(() {
                                  option2 = value;
                                });
                              },
                            ),
                          ),
                          const Divider(
                            color: Color.fromARGB(255, 32,167,219),
                            thickness: 5.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: optionController3,
                              decoration: const InputDecoration(
                                  labelText: "Option 3",
                                  hintText: "Enter Option 3"),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CheckboxListTile(
                              title: const Text("Option 3 is Correct!"),
                              value: option3,
                              onChanged: (bool value) {
                                setState(() {
                                  option3 = value;
                                });
                              },
                            ),
                          ),
                          const Divider(
                            color: Color.fromARGB(255, 32,167,219),
                            thickness: 5.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: optionController4,
                              decoration: const InputDecoration(
                                  labelText: "Option 4",
                                  hintText: "Enter Option 4"),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CheckboxListTile(
                              title: const Text("Option 4 is Correct!"),
                              value: option4,
                              onChanged: (bool value) {
                                setState(() {
                                  option4 = value;
                                });
                              },
                            ),
                          ),
                          const Divider(
                            color: Color.fromARGB(255, 32,167,219),
                            thickness: 5.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FlatButton(
                              child: Text(isEditing ? "UPDATE" : 'ADD '),
                              color: Color.fromARGB(255, 32,167,219),
                              textColor: Colors.white,
                              onPressed: () {
                                if (questionController.text.isEmpty ||
                                    optionController1.text.isEmpty ||
                                    optionController2.text.isEmpty ||
                                    optionController3.text.isEmpty ||
                                    optionController4.text.isEmpty) {
                                  showValidationDialog(context,
                                      "Every text field has to be filled !");
                                } else if (option1 == false &&
                                    option2 == false &&
                                    option3 == false &&
                                    option4 == false) {
                                  showValidationDialog(context,
                                      "Atleast one correct answer has to be selected !");
                                } else {
                                  if (isEditing == true) {
                                    updateQuestion();
                                  } else {
                                    addQuestion();
                                  }
                                  Navigator.of(context).pop();
                                  reinitializeState();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

  ///Deletes all the questions by calling the Delete All method in the question controller
  _deleteAllQuestions() {
    List<Definition> questionsList = _resultsList
        .map((e) => Definition.fromJson(e.data(), e.reference))
        .toList();
    definitionController.deleteAllQuestions(questionsList);
    _showDeleteAllToastMessage();
  }

//Load all the questions to the build body as a widget
  Widget buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: definitionController.getAllDefinitions(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
        if (snapshot.hasData) {
          print("Document -> ${snapshot.data.docs.length}");
          _resultsList = snapshot.data.docs;
          //Renders the question list based on the search criteria
          if (_searchController.text.isEmpty) {
            return buildList(
                context, _sortListByCreatedDateTimeDesc(_resultsList));
          } else {
            return buildList(context, _searchResultsList);
          }
        }
      },
    );
  }

  ///  Sort FireStore Collection Documents By Created Date DESC
  List<QueryDocumentSnapshot> _sortListByCreatedDateTimeDesc(
      queryDocumentSnapshotList) {
    queryDocumentSnapshotList.sort((a, b) {
      //Null Value Check
      Timestamp timeStampA = a.data().keys.contains("createdDateTime")
          ? a.data()["createdDateTime"]
          : null;
      Timestamp timeStampB = b.data().keys.contains("createdDateTime")
          ? b.data()["createdDateTime"]
          : null;
      if (timeStampA == null) {
        return 1;
      } else if (timeStampB == null) {
        return -1;
      } else if (timeStampA == null && timeStampB == null) {
        return 0;
      }
      int result = timeStampA.compareTo(timeStampB);
      if (result == 1) {
        return -1;
      } else if (result == -1) {
        return 1;
      }
      return result;
    });
    return queryDocumentSnapshotList;
  }

//Load list and convert to a list view
  Widget buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    int _currentQuestionNumber = 0;

    return ListView(
        children: snapshot
            .map((data) =>
                listItemBuild(context, data, ++_currentQuestionNumber))
            .toList());
  }

//Load Single Question Object a single item
  Widget listItemBuild(
      BuildContext context, DocumentSnapshot data, int questionNumber) {
    final questionObj = Definition.fromJson(data.data(), data.reference);
    final String formattedQuestionNumberText =
        " " + questionNumber.toString() + " ";

    return Padding(
        key: ValueKey(questionObj.question),
        padding: const EdgeInsets.symmetric(vertical: 19, horizontal: 1),
        child: Dismissible(
            key: new Key(
                questionObj.id.toString() + Random().nextInt(10000).toString()),
            background: Container(
              color: const Color.fromARGB(255, 32,167,219),
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
                  title: Column(
                    children: <Widget>[
                      Row(children: <Widget>[
                        Container(
                          child: Text(formattedQuestionNumberText,
                              style: const TextStyle(color: Colors.white)),
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Color.fromARGB(255, 32,167,219)),
                          padding: const EdgeInsets.all(3.0),
                          margin: const EdgeInsets.only(right: 5.0),
                        ),
                        Flexible(
                            child: SubstringHighlight(
                          text: questionObj.question,
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
                      const Divider(),
                      Row(children: <Widget>[
                        Container(
                          child: const Icon(Icons.question_answer_rounded,
                              color: Colors.orange),
                          margin: const EdgeInsets.only(right: 3.0),
                        ),
                        Flexible(
                            child: SubstringHighlight(
                          text: questionObj.options[0],
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
                        if (questionObj.answers[0])
                          const Icon(Icons.check_circle_outline_rounded,
                              color: Colors.green),
                      ]),
                      Row(children: <Widget>[
                        Container(
                          child: const Icon(Icons.question_answer_rounded,
                              color: Colors.orange),
                          margin: const EdgeInsets.only(right: 3.0),
                        ),
                        Flexible(
                            child: SubstringHighlight(
                          text: questionObj.options[1],
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
                        if (questionObj.answers[1])
                          const Icon(Icons.check_circle_outline_rounded,
                              color: Colors.green),
                      ]),
                      Row(children: <Widget>[
                        Container(
                          child: const Icon(Icons.question_answer_rounded,
                              color: Colors.orange),
                          margin: const EdgeInsets.only(right: 3.0),
                        ),
                        Flexible(
                            child: SubstringHighlight(
                          text: questionObj.options[2],
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
                        if (questionObj.answers[2])
                          const Icon(Icons.check_circle_outline_rounded,
                              color: Colors.green),
                      ]),
                      Row(children: <Widget>[
                        Container(
                          child: const Icon(Icons.question_answer_rounded,
                              color: Colors.orange),
                          margin: const EdgeInsets.only(right: 3.0),
                        ),
                        Flexible(
                            child: SubstringHighlight(
                          text: questionObj.options[3],
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
                        if (questionObj.answers[3])
                          const Icon(Icons.check_circle_outline_rounded,
                              color: Colors.green),
                      ]),
                    ],
                  ),
                  trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _showDeleteAlertDialogBox(context, questionObj);
                      }),
                  onTap: () {
                    setUpdateUI(questionObj);
                  },
                ),
              ),
            ),
            onDismissed: (DismissDirection direction) {
              var value = _isFirstTimeQuickDelete();
              value.then((result) =>
                  {_performQuickDeletion(direction, result, questionObj)});
            }));
  }

  ///Performs the quick deletion
  _performQuickDeletion(
    DismissDirection direction,
    bool isFirstTime,
    Definition question,
  ) {
    if (direction == DismissDirection.endToStart) {
      if (isFirstTime) {
        _showFirstTimeQuickDeleteAlert(context, question);
      } else {
        definitionController.deleteQuestion(question);
        _showDeleteItemToastMessage();
      }
    } else {
      if (isFirstTime) {
        _showFirstTimeQuickDeleteAlert(context, question);
      } else {
        
        definitionController.deleteQuestion(question);
        _showDeleteItemToastMessage();
      }
    }
  }

  ///Checks whether the user is attempting to use the quick deletion for the first time
  Future<bool> _isFirstTimeQuickDelete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool currentValue = prefs.getBool('isDisplayedDeleteNotification');

    if (currentValue == null || !currentValue) {
      await prefs.setBool('isDisplayedDeleteNotification', true);
      return true;
    }

    return false;
  }

  ///Loads the quick delete operation confirmation alert in the first attempt
  _showFirstTimeQuickDeleteAlert(BuildContext context, Definition questionObj) {
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
        _deleteQuestion(questionObj);
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
              'A horizontal swipe of an item will perform a quick deletion of the item, Are you sure you want to continue?',
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
                      child:
                          const Icon(Icons.lightbulb, color: Color.fromARGB(255, 32,167,219), size: 21),
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
              'assets/img/logo.jpg',
              fit: BoxFit.cover,
              height: 60.0,
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Guess The Word',
                style: TextStyle(fontFamily: 'Righteous', fontSize: 20.0),
              ),
            )
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 32,167,219),
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
            Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: const [
              Icon(Icons.list_alt_sharp, color: Color.fromARGB(255, 32,167,219), size: 30),
              Text(
                " DEFINITION LIST",
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
                  ),
                  suffixIcon: IconButton(
                      color: Colors.black,
                      icon: const Icon(Icons.clear),
                      iconSize: 20.0,
                      onPressed: () => _searchController.clear()),
                  contentPadding: const EdgeInsets.only(left: 25.0),
                  hintText: 'Search by definition',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0))),
            ),
            Flexible(child: buildBody(context))
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        backgroundColor: const Color.fromARGB(255, 32,167,219),
        closeManually: true,
        child: const Icon(Icons.sort),
        children: [
          SpeedDialChild(
            //Add new Question floating action button
            child: const Icon(Icons.add),
            backgroundColor: const Color.fromARGB(255, 32,167,219),
            onTap: () => {viewAddUpdateDialogBox(context)},
          ),
          SpeedDialChild(
            //Delete All Questions floating action button
            child: const Icon(Icons.delete),
            backgroundColor: Colors.red,
            onTap: () => {_showDeleteAllAlertDialogBox(context)},
          )
        ],
      ),
    );
  }
}
