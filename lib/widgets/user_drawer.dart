import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wordly/models/review.dart';
import 'package:wordly/screens/admin_users.dart';
import 'package:wordly/screens/home.dart';
import 'package:wordly/screens/userLeaderboard.dart';
import 'package:wordly/screens/user_profile.dart';
import 'package:wordly/utils/color.dart';
import 'package:wordly/screens/definitions.dart';
import 'package:wordly/screens/definition_welcomesplash.dart';

import '../screens/leaderboard.dart';
import '../screens/review.dart';

class UserDrawer extends StatelessWidget {
  const UserDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final user = _auth.currentUser;
    navigateLogin() async {
      Navigator.pushReplacementNamed(context, "login"); 
    }
    
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: purpleLightColors,
            child: Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(top: 30, bottom: 30),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/img/user.png'),
                      ),
                    ),
                  ),
                  user != null
                      ? Text(
                          user.email!,
                          style: TextStyle(
                              color: white,
                              fontSize: 18,
                              fontFamily: 'Righteous'),
                        )
                      : const Text(''),
                ],
              ),
            ),
          ),        
                    ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
          ),

            ListTile(
            leading: const Icon(Icons.person_outline_outlined),
            title: const Text('Profile'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const UserProfileScreen()));
            },
          ),
            ListTile(
            leading: const Icon(Icons.star_half_rounded),
            title: const Text('Add Review'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ReviewScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.leaderboard_outlined),
            title: const Text('Leaderboard'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ULeaderBoard()));
            },
          ),

          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Sign out'),
            onTap: () async {
              await _auth.signOut().then((value) => navigateLogin());
            },
          ),
        ],
      ),
    );
  }
}
