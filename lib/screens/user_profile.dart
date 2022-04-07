import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:wordly/screens/home.dart';
import 'package:wordly/utils/color.dart';
import 'package:wordly/widgets/header_container.dart';

import '../controllers/user_controller.dart';
import '../models/user.dart';
import '../widgets/main_drawer.dart';
import '../widgets/user_drawer.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);



  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final userController = UserController();
  


  // ignore: non_constant_identifier_names
  late String userName, userEmail, _Name;
  late int userPoints = 0;
  late dynamic userProf;

  @override
  void initState() {
    super.initState();

  }

  getUserDetils() async{
     final user = _auth.currentUser;
     userProf = await userController.getUserData(user?.email.toString());
     if ( userProf != null){
     setState(() {
      userName = userProf['name'];
      userEmail = userProf['email'];
      userPoints = userProf['points'];      
     });
     }
  }

  
  updateUserDetails() async{
    try{
     await userController.updateUserDetails(userName,userEmail);
     showUpdateAlert();
    } catch (e) {
          showError(e.toString());
    }
  }

  deleteUser() async{
    try{  
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Are you sure you want to permanently delete this user?'),
            actions: <Widget>[
              TextButton(
                  onPressed: () async {
                    await userController.deleteUser(userEmail);
                    showAlert();                
                  },
                  child: const Text('OK'),
                  ),
              
              TextButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
              child: const Text('cancel')),
            ],
          );
        });    
      
    } catch (e) {
          showError(e.toString());
    }
   
  }

  showAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Successfully Deleted User'),
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

  showUpdateAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Successfully Updated User'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    navigateToProfile();
                  },
                  child: const Text('OK')),
            ],
          );
        });
  }

  navigateToHome() async {
      Navigator.pushReplacementNamed(context, "welcome");
  }

  navigateToProfile() async {
      Navigator.pushReplacementNamed(context, "userProfile");
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
    return FutureBuilder(
      future: getUserDetils(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Scaffold(
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
      drawer: const UserDrawer(),
      body: Container(
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          children: <Widget>[
            
            Expanded(
              flex: 1,     
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,               
                  child: Column(
                    children: <Widget>[
                      Container(),
                      const SizedBox(
                        height: 30,
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: const [
                          Icon(Icons.verified_user,
                              color: Color.fromARGB(255, 28,150,197), size: 30),
                          Text(
                            "USER PROFILE",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                          )
                        ]),
                      const SizedBox(
                        height: 40.0,
                      ),
                      TextFormField(
                        // ignore: missing_return
                        initialValue: userName,
                        validator: (input) {
                          if (input!.isEmpty) return 'Enter Name';
                        },
                        decoration: const InputDecoration(
                            labelText: 'Name', prefixIcon: Icon(Icons.person)),
                        onChanged: (String value) async{
                          userName = value;
                        },
                      ),
                      TextFormField(
                        // ignore: missing_return
                        initialValue: userEmail,
                        readOnly : true,
                        validator: (input) {
                          if (input!.isEmpty) return 'Enter Email';
                        },
                        decoration: const InputDecoration(
                            labelText: 'Email', prefixIcon: Icon(Icons.email)),
                      ),
                      TextFormField(
                        // ignore: missing_return
                        initialValue: userPoints.toString(),
                        readOnly : true,
                        decoration: const InputDecoration(
                        labelText: 'Points',
                        prefixIcon: Icon(Icons.point_of_sale)),
                      ),
                    const SizedBox(
                      height: 50.0,
                    ),                   
                      Row(
                        children: <Widget>[
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
                            onPressed: updateUserDetails,
                            child: const Text(
                              'Edit',
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                          width: 40.0,
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
                            onPressed: deleteUser,
                            child: const Text(
                              'Delete',
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
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
  });

  }
}

