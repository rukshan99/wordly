
import 'package:flutter/material.dart';
import 'package:wordly/utils/color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  navigateQuiz() async {
    Navigator.pushReplacementNamed(context, "quiz");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: purpleLightColors,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Center(
              child: Image.asset('assets/img/Logo.png'),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: purpleColors, // background
              onPrimary: Colors.white,
              padding: EdgeInsets.fromLTRB(100, 15, 100, 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0)), // foreground
            ),
            onPressed: () {
              navigateQuiz();
            },
            child: Text(
              'Start Quiz',
              style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
          ),
        ],
      ),
    );
  }
}
