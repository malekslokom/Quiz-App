//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../helper/helper_function.dart';
import '../service/auth_service.dart';
import 'adminHomePage.dart';
import 'home.dart';

class AdminDashboard extends StatefulWidget {
  final String quizCode;

  const AdminDashboard({
    Key? key,
    required this.quizCode,
  }) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  AuthService authService = AuthService();
  String userName = "";
  String email = "";
  List<Map<String, dynamic>>? _quizData;
  Map<String, dynamic>? _participantsData;
  @override
  void initState() {
    super.initState();
    getUserData();
    _loadQuizSnapshot();
  }

  getUserData() async {
    await HelperFunctions.getUserEmail().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserName().then((value) {
      setState(() {
        userName = value!;
      });
    });
  }

  Future<void> _loadQuizSnapshot() async {
    try {
      final quizPartyDoc = await FirebaseFirestore.instance
          .collection('quizParty')
          .doc(widget.quizCode)
          .get();

      if (quizPartyDoc.exists) {
        // final participants = quizPartyDoc.data()!['participants'];
        final participants =
            Map<String, dynamic>.from(quizPartyDoc.data()!['participants']);
        print(participants);
        final quizzesDoc = await FirebaseFirestore.instance
            .collection('quizzes')
            .doc(widget.quizCode)
            .get();

        if (quizzesDoc.exists) {
          final quizData = quizzesDoc.data();
          if (quizData != null && quizData['questions'] is List) {
            final questions =
                List<Map<String, dynamic>>.from(quizData['questions']);

            setState(() {
              _participantsData = participants;
              _quizData = questions;
              print(_quizData);
            });
          }
        }
      }
    } catch (e) {
      print('Error fetching quiz data: $e');
    }
  }

  List<Map<String, double>> calculateParticipantScores() {
    List<Map<String, double>> scoreOfParticipants = [];
    if (_participantsData == null || _quizData == null) {
      return scoreOfParticipants;
    }

    int? numberOfQuestions = _quizData!.length;

    for (String participantId in _participantsData!.keys) {
      double score = 0.0;

      if (_participantsData![participantId]!['response'] != null) {
        List participantResponses =
            _participantsData![participantId]!['response'];

        if (participantResponses.length == numberOfQuestions) {
          for (int j = 0; j < numberOfQuestions; j++) {
            if (_quizData != null &&
                _quizData![j]['correctAnswer'] != null &&
                participantResponses[j] != null &&
                _quizData![j]['correctAnswer'] == participantResponses[j]) {
              score +=
                  (10 + _participantsData![participantId]!['timers']![j] / 3);
            }
          }
        }
      }

      scoreOfParticipants.add({participantId: score.roundToDouble()});
    }
    print("scoreOfParticipants");
    print(scoreOfParticipants);

    scoreOfParticipants
        .sort((a, b) => b.values.first.compareTo(a.values.first));
    return scoreOfParticipants;
  }

  @override
  Widget build(BuildContext context) {
    if (_quizData == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('User Dashboard'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final List<Map<String, double>> participantScores =
        calculateParticipantScores();

    return Scaffold(
      backgroundColor: Color(0xff151a3b),
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Leaderboard",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 27,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: Drawer(
          backgroundColor: Color(0xff151a3b),
          child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 50),
              children: [
                const Icon(
                  Icons.account_circle,
                  size: 150,
                  color: Colors.white,
                ),
                const SizedBox(
                  height: 18,
                ),
                Text(
                  userName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Divider(
                  height: 2,
                  color: Colors.white,
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const AdminHomePage()));
                  },
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  leading: const Icon(
                    Icons.quiz,
                    color: Colors.white,
                  ),
                  title: const Text(
                    "Quizzes",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  selectedColor: Theme.of(context).primaryColor,
                  selected: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  leading: const Icon(
                    Icons.quiz,
                  ),
                  title: const Text(
                    "Quiz Party",
                    style: TextStyle(),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  leading: const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  title: const Text(
                    "Profile",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () async {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Logout"),
                          content:
                              const Text("Are you sure you want to logout?"),
                          actions: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                await authService.signOut();
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const Home(),
                                  ),
                                  (route) => false,
                                );
                              },
                              icon: const Icon(
                                Icons.done,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  leading: const Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                  title: const Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ])),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              itemCount: participantScores.length,
              itemBuilder: (context, index) {
                final participant = participantScores[index];
                final isTopThree = index < 3;
                IconData? medalIcon;
                Color? color;
                if (isTopThree) {
                  if (index == 0) {
                    medalIcon = Icons.emoji_events;
                    color = Colors.amber; // Gold medal icon
                  } else if (index == 1) {
                    medalIcon = Icons.emoji_events;
                    color = const Color.fromRGBO(
                        192, 192, 192, 1.0); // Silver medal icon
                  } else if (index == 2) {
                    medalIcon = Icons.emoji_events;
                    color = Color(0xFFCD7F32); // Bronze medal icon
                  }
                }

                return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: ListTile(
                      leading: isTopThree
                          ? Icon(
                              medalIcon,
                              color: color,
                            )
                          : Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                      title: Text('${participant.keys.first}',
                          style: TextStyle(
                            color: Colors.white,
                          )),
                      trailing: Text(
                        '${participant.values.first}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
