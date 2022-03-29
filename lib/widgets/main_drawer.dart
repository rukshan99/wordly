import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wordly/screens/admin_users.dart';
import 'package:wordly/utils/color.dart';

import '../screens/leaderboard.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final user = _auth.currentUser;
    navigateLogin() async {
      Navigator.pushReplacementNamed(context, "login");
    }

    navigateToReview() async {
      Navigator.pushReplacementNamed(context, "review");
    }

    navigateToReviewList() async {
      Navigator.pushReplacementNamed(context, "reviewList");
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
            leading: const Icon(Icons.supervised_user_circle_outlined),
            title: const Text('User list'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const UserList()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.leaderboard_outlined),
            title: const Text('Leaderboard'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LeaderBoard()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.star_half_rounded),
            title: const Text('Add review'),
            onTap: () => {navigateToReview()},
          ),
          ListTile(
            leading: const Icon(Icons.reviews_sharp),
            title: const Text('Review List'),
            onTap: () => {navigateToReviewList()},
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
