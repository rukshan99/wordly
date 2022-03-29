import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wordly/models/review.dart';
import 'package:wordly/utils/color.dart';
import 'package:wordly/widgets/header_container.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../controllers/review_controller.dart';
import '../models/user.dart';
import 'package:wordly/widgets/main_drawer.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({Key? key}) : super(key: key);

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final reviewController = ReviewController();

  late String _comment,_email;
  late double _ratingValue = 0 ;

  TextEditingController textarea = TextEditingController();

  submit() async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        try {
            Review reviewObj = Review(email: _email,ratingValue: _ratingValue, comment: _comment);
            await reviewController.addReview(reviewObj);
            showAlert();
    
        } catch (e) {
          showError(e.toString());
        }
      }
  }

  showAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Successfully added'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    navigateToHome();
                  },
                  child: const Text('OK')),
            ],
          );
        });
  }
  navigateToReview() async {
      Navigator.pushReplacementNamed(context, "review");
  }

  navigateToHome() async {
      Navigator.pushReplacementNamed(context, "home");
  }

  showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('ERROR'),
            content: Text(errormessage),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK')),
            ],
          );
        });
  }


  @override
  void initState() {
    super.initState();
  }


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
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          children: <Widget>[         
            Expanded(
              flex: 1,
              child: Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(),
                      const SizedBox(
                        height: 60,
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: const [
                          Icon(Icons.reviews_rounded,
                              color: Color.fromARGB(255, 28,150,197), size: 30),
                          Text(
                            "ADD REVIEW",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                          )
                        ]),
                       const SizedBox(
                        height: 50.0,
                      ),
                      RatingBar(
                        initialRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        ratingWidget: RatingWidget(
                        full: const Icon(Icons.star, color: Colors.orange),
                        half: const Icon(
                          Icons.star_half,
                          color: Colors.orange,
                        ),
                        empty: const Icon(
                          Icons.star_outline,
                          color: Colors.orange,
                        )),
                        onRatingUpdate: (value) {
                          setState(() {
                            _ratingValue = value;
                          });
                        }),
                        
                      const SizedBox(height: 5.0),
                      // Display the rate in number
                      Container(
                        width: 50,
                        height: 50,
                        // decoration: const BoxDecoration(
                        //     color: Colors.red, shape: BoxShape.rectangle),
                        alignment: Alignment.center,
                        child: Text(
                          _ratingValue != null ? _ratingValue.toString() : 'Rate it!',
                          style: const TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      TextFormField(
                        // ignore: missing_return
                        validator: (input) {
                          if (input!.isEmpty) return 'Enter Email';
                        },
                        decoration: const InputDecoration(
                            labelText: 'Email', prefixIcon: Icon(Icons.email)),
                        onSaved: (input) => _email = input!,
                      ),
                     const SizedBox(
                        height: 30.0,
                      ),
                      TextFormField(
                        // ignore: missing_return
                        keyboardType: TextInputType.multiline,
                        // maxLines: 3,
                        controller: textarea,
                        validator: (input) {
                          if (input!.isEmpty) return 'Enter Comment';
                        },
                        decoration: const InputDecoration(  
                          labelText: 'comment', 
                          prefixIcon: Icon(Icons.comment)
                        ),
                        onSaved: (input) => _comment = input!,
                      ),
                      const SizedBox(
                        height: 80.0,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: purpleColors, 
                          onPrimary: Colors.white,
                          padding: const EdgeInsets.fromLTRB(100, 15, 100, 15),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(100.0)),
                        ),
                        onPressed: submit,
                        child: const Text(
                          'SUBMIT',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      ],                
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
    
  }

}

