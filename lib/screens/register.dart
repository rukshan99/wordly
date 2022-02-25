import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:wordly/screens/home.dart';
import 'package:wordly/utils/color.dart';
import 'package:wordly/widgets/header_container.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String _name, _email, _password;

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) async {
      if (user != null) {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentification();
  }

  signUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        UserCredential user = await _auth.createUserWithEmailAndPassword(
            email: _email, password: _password);
        if (user != null) {
          await _auth.currentUser!.updateProfile(displayName: _name);
        }
      } catch (e) {
        showError(e.toString());
      }
    }
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
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          children: <Widget>[
            HeaderContainer("Register"),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 30.0,
                      ),
                      TextFormField(
                        // ignore: missing_return
                        validator: (input) {
                          if (input!.isEmpty) return 'Enter Name';
                        },
                        decoration: const InputDecoration(
                            labelText: 'Name',
                            prefixIcon: Icon(Icons.person)),
                        onSaved: (input) => _name = input!,
                      ),
                      TextFormField(
                        // ignore: missing_return
                        validator: (input) {
                          if (input!.isEmpty) return 'Enter Email';
                        },
                        decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email)),
                        onSaved: (input) => _email = input!,
                      ),
                      TextFormField(
                        // ignore: missing_return
                        validator: (input) {
                          if (input!.length < 6) {
                            return 'Provide Minimum 6 Character Password';
                          }
                        },
                        decoration: const InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock)),
                        obscureText: true,
                        onSaved: (input) => _password = input!,
                      ),
                      const SizedBox(
                        height: 50.0,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: purpleColors, // background
                          onPrimary: Colors.white,
                          padding: const EdgeInsets.fromLTRB(100, 15, 100, 15),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(100.0)), // foreground
                        ),
                        onPressed: signUp,
                        child: const Text(
                          'SIGNUP',
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