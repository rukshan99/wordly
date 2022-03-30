// @dart=2.9
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordly/providers/user_provider.dart';
import 'package:wordly/screens/leaderboard.dart';
import 'package:wordly/screens/login.dart';
import 'package:wordly/screens/register.dart';
import 'package:wordly/screens/splash.dart';
import 'package:wordly/screens/welcome.dart';
import 'package:wordly/screens/admin_users.dart';
import 'package:wordly/screens/definitions.dart';
import 'package:wordly/screens/quiz.dart';
import 'package:wordly/screens/home.dart';
import 'package:wordly/screens/definition_welcomesplash.dart';
import 'package:wordly/screens/review.dart';
import 'package:wordly/screens/reviewList.dart';
import 'package:firebase_auth/firebase_auth.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
       primarySwatch: Colors.blue,
        
      ),
      home:
          _auth.currentUser != null ? const HomeScreen() : const SplashScreen(),
      routes: <String, WidgetBuilder>{
        "login": (BuildContext context) => const LoginScreen(),
        "register": (BuildContext context) => const RegisterScreen(),
        "welcome": (BuildContext context) => const WelcomeScreen(),
        "userList": (BuildContext context) => const UserList(),
        "definitionList":(BuildContext context) => definitionList(),
        "home": (BuildContext context) => const HomeScreen(),
        "quiz": (BuildContext context) => QuizScreen(),
        "leaderboard": (BuildContext context) => const LeaderBoard(),
        "definitionAdminWelcome":(BuildContext context) => DefinitionAdminWelcomeSplashScreen(),
        "review": (BuildContext context) => const ReviewScreen(),
        "reviewList": (BuildContext context) => const ReviewListScreen(),
      },
    ));
  }
}
