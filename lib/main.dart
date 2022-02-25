import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wordly/screens/login.dart';
//import 'package:guess_app/screens/register.dart';
import 'package:wordly/screens/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final FirebaseAuth _auth = FirebaseAuth.instance;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const WelcomeScreen(), //_auth.currentUser != null ? HomeScreen() : SplashScreen(),
      routes: <String, WidgetBuilder>{
        "login": (BuildContext context) => const LoginScreen(),
        //"register": (BuildContext context) => RegisterScreen(),
        "welcome": (BuildContext context) => const WelcomeScreen()
      },
    );
  }
}
