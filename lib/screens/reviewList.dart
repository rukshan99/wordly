import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:wordly/providers/review_provider.dart';
import 'package:wordly/widgets/main_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../controllers/review_controller.dart';
import '../models/review.dart';

class ReviewListScreen extends StatefulWidget {
  const ReviewListScreen({Key? key}) : super(key: key);

  @override
  _ReviewListScreenState createState() => _ReviewListScreenState();
}

class _ReviewListScreenState extends State<ReviewListScreen> {

  final reviewController = ReviewController();

  final TextEditingController _searchController = TextEditingController();

  List<QueryDocumentSnapshot> _resultsList = [];

  List<QueryDocumentSnapshot> _searchResultsList = [];


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
      Review currentReview = Review.fromJson(
          element.data() as Map<String, dynamic>, element.reference);
      String formattedSearchText = _searchController.text.toLowerCase();

      if (currentReview.email.toLowerCase().contains(formattedSearchText)) {
        filteredResultsList.add(element);
      }
    });
    setState(() {
      _searchResultsList = filteredResultsList;
    });
  }

  Widget buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: reviewController.getAllReviews(),
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
    int _currentReviewNumber= 0;

    return ListView(
        children: snapshot
            .map((data) => listItemBuild(context, data, ++_currentReviewNumber))
            .toList());
  }

  //Load Single Review Object a single item
  Widget listItemBuild(
      BuildContext context, DocumentSnapshot data, int reviewNumber) {
    final reviewObj =
        Review.fromJson(data.data() as Map<String, dynamic>, data.reference);
    final String formattedReviewNumberText = " " + reviewNumber.toString() + " ";

    return Padding(
        key: ValueKey(reviewObj.email),
        padding: const EdgeInsets.symmetric(vertical: 19, horizontal: 1),
        child: Dismissible(
            key: Key(reviewObj.email.toString()+
                Random().nextInt(10000).toString()), 
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
                  title: InkWell(
                    child: Column(children: <Widget>[
                      Row(children: <Widget>[
                        Container(
                          child: Text(formattedReviewNumberText,
                              style: const TextStyle(color: Colors.white)),
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Color.fromARGB(255, 32,167,219)),
                          padding: const EdgeInsets.all(2.0),
                          margin: const EdgeInsets.only(right: 5.0),
                        ),
                        Flexible(
                            child: SubstringHighlight(
                          text: reviewObj.email,
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
                      Row(children: <Widget>[
                        Container(
                          child: const Icon(Icons.email, color: Colors.grey),
                          margin: const EdgeInsets.only(right: 3.0),
                        ),
                        Flexible(
                            child: SubstringHighlight(
                          text: reviewObj.comment,
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
                      Row(children: <Widget>[
                        Container(
                          child: const Icon(Icons.star_half_rounded, color: Colors.yellow),
                          margin: const EdgeInsets.only(right: 3.0),
                        ),
                        Flexible(
                            child: SubstringHighlight(
                          text: reviewObj.ratingValue.toString(),
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
                  ),
                ),
              ),
            ),
            ));
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
        backgroundColor: const Color.fromARGB(255, 28,150,197),
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
                  Icon(Icons.list,
                      color: Color.fromARGB(255, 28,150,197), size: 30),
                  Text(
                    " Review list",
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
                  hintText: 'Search',
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

