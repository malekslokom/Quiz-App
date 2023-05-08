import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../helper/helper_function.dart';
import '../service/auth_service.dart';
import 'adminHomePage.dart';
import 'adminDashboard.dart';
import 'home.dart';

class AdminQuizPartyResult extends StatefulWidget {
  final String quizCode;

  const AdminQuizPartyResult({Key? key, required this.quizCode})
      : super(key: key);

  @override
  State<AdminQuizPartyResult> createState() => _AdminQuizPartyResultState();
}

class _AdminQuizPartyResultState extends State<AdminQuizPartyResult> {
  AuthService authService = AuthService();
  String userName = "";
  String email = "";
  List<Map<String, dynamic>>? _quizData;
  Map<String, dynamic>? _participantsData;
  Map<String, List<int>> participantsData = {};
  List<Map<String, dynamic>> quizData = [];
  @override
  void initState() {
    super.initState();
    getUserData();
    _loadQuizData();
    calculateNewData();
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

  Future<void> _loadQuizData() async {
    try {
      final quizPartyDoc = await FirebaseFirestore.instance
          .collection('quizParty')
          .doc(widget.quizCode)
          .get();

      if (quizPartyDoc.exists) {
        final participants =
            Map<String, dynamic>.from(quizPartyDoc.data()!['participants']);
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
            });
          }
        }
      }
    } catch (e) {
      print('Error fetching quiz data: $e');
    }
    calculateNewData();
  }

  void calculateNewData() {
    if (_participantsData == null) {
      return;
    }
    Map<String, List<int>> participants = {};

    for (String participantId in _participantsData!.keys) {
      if (_participantsData![participantId]!['response'] != null) {
        List<int> participantResponses =
            List<int>.from(_participantsData![participantId]!['response']);

        participants[participantId] = participantResponses;
      }
    }
    if (_quizData == null) {
      return;
    }

    List<Map<String, dynamic>> quizD = [];

    for (int i = 0; i < _quizData!.length; i++) {
      List<String> op = [];
      for (int j = 0; j < _quizData![i]['options'].length; j++) {
        op.add(_quizData![i]['options'][j]["optionText"]);
      }
      quizD.add({'questionText': _quizData![i]['questionText'], 'options': op});
    }

    setState(() {
      quizData = quizD;
      participantsData = participants;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff151a3b),
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Quiz Statistics",
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
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: quizData.length,
        itemBuilder: (context, questionIndex) {
          final question = quizData[questionIndex];
          final options = List<String>.from(question['options']);
          final responseCounts = List<int>.filled(options.length, 0);

          // Count the number of responses for each option
          participantsData.forEach((participant, responses) {
            final responseIndex = responses[questionIndex];
            if (responseIndex < options.length) {
              responseCounts[responseIndex]++;
            }
          });

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Text(
                'Question: ${question['questionText']}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              for (int optionIndex = 0;
                  optionIndex < options.length;
                  optionIndex++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text(
                          options[optionIndex],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 20,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: responseCounts[optionIndex] /
                                participantsData.length,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '${responseCounts[optionIndex]}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              Divider(),
              questionIndex == question.length - 1
                  ? const SizedBox(height: 16)
                  : Container(),
              questionIndex == question.length - 1
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              print("HNEEEE");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AdminDashboard(
                                    quizCode: widget.quizCode,
                                  ),
                                ),
                              );
                            },
                            child: Text('Leaderboard'),
                          ),
                        ),
                      ],
                    )
                  : Container(),
            ],
          );
        },
      ),
    );
  }
}
