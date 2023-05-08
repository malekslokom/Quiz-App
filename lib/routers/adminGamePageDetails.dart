import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/routers/adminHomePage.dart';
import 'package:quiz_app/routers/adminQuizPageDetailsQst.dart';
import '../helper/helper_function.dart';
import '../service/auth_service.dart';
import 'LoadPage.dart';
import 'adminGamePageDetails.dart';
import 'home.dart';

class AdminGamePageDetails extends StatefulWidget {
  final String quizCode;

  const AdminGamePageDetails({Key? key, required this.quizCode})
      : super(key: key);

  @override
  State<AdminGamePageDetails> createState() => _AdminGamePageDetailsState();
}

class _AdminGamePageDetailsState extends State<AdminGamePageDetails> {
  AuthService authService = AuthService();
  Stream<DocumentSnapshot<Map<String, dynamic>>>? _gameStream;

  String userName = "";
  String email = "";
  bool startButton = false;
  bool showResult = false;
  int questionNumber = 0;
  int _selectedOptionIndex = -1;
  bool _isButtonDisabled = false;
  int _secondsLeft = 30;
  bool startButtonbtnDisabled = false;
  List<Map<String, dynamic>>? _quizData;
  Map<String, dynamic>? _participantsData;
  List<String> _participants = [];
  late Timer timer;

  @override
  void initState() {
    super.initState();
    getUserData();
    fetchGameDetails();
    _loadQuizSnapshot();
    super.initState();
    _gameStream = FirebaseFirestore.instance
        .collection('quizParty')
        .doc(widget.quizCode)
        .snapshots();
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

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (Timer timer) {
      setState(() {
        if (_secondsLeft < 1) {
          print("mounted");
          print(mounted);
          final shouldShowBottomSheet =
              mounted && ModalRoute.of(context)?.isCurrent == true;
          if (shouldShowBottomSheet) {
            timer.cancel();
          }
          timer.cancel();
        } else {
          _secondsLeft = _secondsLeft - 1;
        }
      });
    });
  }

  Future<void> fetchGameDetails() async {
    try {
      final gameDoc = await FirebaseFirestore.instance
          .collection('quizParty')
          .doc(widget.quizCode)
          .get();

      if (gameDoc.exists) {
        setState(() {
          startButton = gameDoc.data()?['startButton'] ?? false;
          showResult = gameDoc.data()?['showResult'] ?? false;
          questionNumber = gameDoc.data()?['questionNumber'] ?? 0;
        });
      }
    } catch (e) {
      print('Error fetching game details: $e');
    }
  }

  Future<void> _loadQuizSnapshot() async {
    try {
      final QuizPartyDoc = await FirebaseFirestore.instance
          .collection('quizParty')
          .doc(widget.quizCode)
          .get();

      if (QuizPartyDoc.exists) {
        final participantsData =
            Map<String, dynamic>.from(QuizPartyDoc.data()!['participants']);
        print(participantsData);
        List<String> participants = [];
        for (String participantId in participantsData.keys) {
          participants.add(participantId);
        }
        final quizzesDoc = await FirebaseFirestore.instance
            .collection('quizzes')
            .doc(widget.quizCode)
            .get();
        print("==========???");
        if (quizzesDoc.exists) {
          print("????");
          final quizData = quizzesDoc.data();
          if (quizData != null && quizData['questions'] is List) {
            final questions =
                List<Map<String, dynamic>>.from(quizData['questions']);

            setState(() {
              _participantsData = participantsData;
              _quizData = questions;
              _participants = participants;
              print(_quizData);
            });
            setState(() {});
          }
        }
      }
    } catch (e) {
      print('Error fetching quiz data: $e');
    }
  }

  Future<void> updateGameDetails() async {
    try {
      print(startButton);
      await FirebaseFirestore.instance
          .collection('quizParty')
          .doc(widget.quizCode)
          .update({
        'startButton': startButton,
        'showResult': showResult,
        'questionNumber': questionNumber,
      });
    } catch (e) {
      print('Error updating game details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_quizData == null || _quizData!.length <= questionNumber) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final currentQuestion = _quizData![questionNumber];
    return Scaffold(
        backgroundColor: Color(0xff151a3b),
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            "Quiz Party",
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

        // Rest of your code here
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: _gameStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData) {
              return Text('No data available');
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            final gameData = snapshot.data!.data()!["participants"];
            print("gameData");
            print(gameData);
            print("_participantsData");
            print(_participantsData);

            return Container(
              // Your existing code here
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      // child: Text("Number of participants = ${_participants.length}",
                      //     style: TextStyle(color: Colors.white)),

                      child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: gameData!.length,
                    itemBuilder: (context, index) {
                      final participant = gameData!.keys.elementAt(index);
                      return Container(
                        child: ListTile(
                          leading: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            '$participant',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  )),
                  Flexible(
                    child: AbsorbPointer(
                      absorbing: startButtonbtnDisabled,
                      child: ElevatedButton(
                        child: const Text('Start Quiz'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdminQuizPageDetailsQst(
                                      quizCode: widget.quizCode,
                                    )),
                          );
                          setState(() {
                            startButton = true;
                            startButtonbtnDisabled = true;
                            updateGameDetails();
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
