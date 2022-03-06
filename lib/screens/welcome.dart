import 'package:flutter/material.dart';
import 'package:wordly/utils/color.dart';
import 'package:wordly/widgets/header_container.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  navigateToLogin() async {
    Navigator.pushReplacementNamed(context, "login");
  }

  navigateToRegister() async {
    Navigator.pushReplacementNamed(context, "register");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          children: <Widget>[
            HeaderContainer(''),
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 40),
                child: Column(
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        text: 'Welcome To ',
                        style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                            color: purpleColors),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Wordly',
                            style: TextStyle(
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                                color: purpleColors),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Refresh the knowledge and improve your vocabulary',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20.0, color: purpleLightColors),
                    ),
                    const SizedBox(
                      height: 100.0,
                    ),
                    Row(
                      children: <Widget>[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: purpleColors, // background
                            onPrimary: Colors.white,
                            padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(100.0)), // foreground
                          ),
                          onPressed: navigateToLogin,
                          child: const Text(
                            'LOGIN',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          width: 30.0,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: purpleColors, // background
                            onPrimary: Colors.white,
                            padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(100.0)), // foreground
                          ),
                          onPressed: navigateToRegister,
                          child: const Text(
                            'REGISTER',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
