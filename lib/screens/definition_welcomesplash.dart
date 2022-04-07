// @dart=2.9

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wordly/screens/definitions.dart';
import 'package:wordly/utils/color.dart';


class DefinitionAdminWelcomeSplashScreen extends StatefulWidget {
  @override
  _DefinitionAdminWelcomeSplashScreen createState() => _DefinitionAdminWelcomeSplashScreen();
}

class _DefinitionAdminWelcomeSplashScreen extends State<DefinitionAdminWelcomeSplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(milliseconds: 2000), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => definitionList()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (  
      backgroundColor: purpleColors,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset('assets/img/logo.jpg'),
          ),
          const SizedBox(
            height: 25,
             child: Text(
              'Welcome to Guess The Word Admin App !',
              style: TextStyle(fontSize: 18,color: Colors.white),
              
            ),
          ),
        ],
      ),
    );
  }
}
