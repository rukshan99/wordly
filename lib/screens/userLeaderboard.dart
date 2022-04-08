// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wordly/widgets/user_drawer.dart';

class ULeaderBoard extends StatefulWidget {
  const ULeaderBoard({Key? key}) : super(key: key);

  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<ULeaderBoard> {
  int i = 0;
  // ignore: non_constant_identifier_names
  Color my = Colors.brown, CheckMyColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    var r = const TextStyle(color: Colors.purpleAccent, fontSize: 34);
    return Stack(
      children: <Widget>[
        Scaffold(
            resizeToAvoidBottomInset: false,
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
              backgroundColor: const Color.fromARGB(255, 28, 150, 197),
            ),
            drawer: const UserDrawer(),
            body: Container(
              margin: const EdgeInsets.only(top: 65.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: const [
                        Icon(Icons.leaderboard_rounded,
                            color: Color.fromARGB(255, 28, 150, 197), size: 30),
                        Text(
                          " LEADERBOARD",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w800),
                        )
                      ]),
                  const SizedBox(
                    height: 20,
                  ),
                  Flexible(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .orderBy('points', descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              i = 0;
                              return ListView.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    print(index);
                                    if (index >= 1) {
                                      print('Greater than 1');
                                      if (snapshot.data!.docs[index]
                                              .get('points') ==
                                          snapshot.data!.docs[index - 1]
                                              .get('points')) {
                                        print('Same');
                                      } else {
                                        i++;
                                      }
                                    }

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0, vertical: 5.0),
                                      child: InkWell(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: i == 0
                                                      ? Colors.amber
                                                      : i == 1
                                                          ? Colors.grey
                                                          : i == 2
                                                              ? Colors.brown
                                                              : Colors.white,
                                                  width: 3.0,
                                                  style: BorderStyle.solid),
                                              borderRadius:
                                                  BorderRadius.circular(5.0)),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 7.5,
                                                            bottom: 7.5,
                                                            left: 15.0),
                                                    child: Row(
                                                      children: <Widget>[
                                                        CircleAvatar(
                                                            child: Container(
                                                                decoration: const BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    image: DecorationImage(
                                                                        image: AssetImage(
                                                                            'assets/img/user.png'),
                                                                        fit: BoxFit
                                                                            .fill)))),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20.0,
                                                            top: 10.0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              snapshot.data!
                                                                  .docs[index]
                                                                  .get('name'),
                                                              style: const TextStyle(
                                                                  color: Color.fromARGB(255, 37, 85, 173),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                              maxLines: 6,
                                                            )),
                                                        Text("Points: " +
                                                            snapshot.data!
                                                                .docs[index]
                                                                .get('points')
                                                                .toString()),
                                                      ],
                                                    ),
                                                  ),
                                                  Flexible(child: Container()),
                                                  i == 0
                                                      ? Text("🥇", style: r)
                                                      : i == 1
                                                          ? Text(
                                                              "🥈",
                                                              style: r,
                                                            )
                                                          : i == 2
                                                              ? Text(
                                                                  "🥉",
                                                                  style: r,
                                                                )
                                                              : const Text(''),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          }))
                ],
              ),
            )),
      ],
    );
  }
}
