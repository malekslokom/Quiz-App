import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/routers/adminHomePage.dart';
import 'package:quiz_app/routers/adminQuizPageDetailsQst.dart';
import '../helper/helper_function.dart';
import '../service/auth_service.dart';
import 'LoadPage.dart';
import 'adminQuizPageDetailsQst.dart';
import 'adminQuizPartyResult.dart';
import 'home.dart';

class AdminQuizPageDetailsQst extends StatefulWidget {
  final String quizCode;
  const AdminQuizPageDetailsQst({Key? key, required this.quizCode})
      : super(key: key);

  @override
  State<AdminQuizPageDetailsQst> createState() =>
      _AdminQuizPageDetailsQstState();
}

class _AdminQuizPageDetailsQstState extends State<AdminQuizPageDetailsQst> {
  AuthService authService = AuthService();
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
    _startTimer();
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
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  color: Colors.red,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Time is out',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          timer.cancel();
        } else {
          _secondsLeft = _secondsLeft - 1;
        }
      });
    });
  }

  void _handleNextQuestion() {
    if (questionNumber < _quizData!.length) {
      setState(() {
        _isButtonDisabled = true;

        _secondsLeft = 30;
      });
    } else {
      // Handle end of quiz
      print('End of Quiz');
    }
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
    _handleNextQuestion();
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
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${questionNumber + 1}:',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.timer, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      '$_secondsLeft s',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xff1D9EA7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(
              thickness: 1,
              color: Colors.grey,
              height: 20,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                currentQuestion['questionText'] ?? '',
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              itemCount: currentQuestion['options'].length,
              itemBuilder: (context, index) {
                final option = currentQuestion['options'][index]['optionText'];

                return ListTile(
                  title: Text(
                    option,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  leading: Theme(
                    data: ThemeData(
                      unselectedWidgetColor: Colors.white,
                    ),
                    child: Radio(
                      value: index,
                      groupValue: currentQuestion['correctAnswer'],
                      onChanged: (value) {
                        setState(() {
                          _selectedOptionIndex =
                              currentQuestion['correctAnswer'];
                        });
                      },
                      // Add the following line to check the radio button for the correct answer
                      activeColor: index == currentQuestion['correctAnswer']
                          ? Colors.green
                          : null,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  child: Text(questionNumber == _quizData!.length - 1
                      ? 'Final Question'
                      : 'Next question'),
                  onPressed: () {
                    setState(() {
                      print(_quizData!.length);
                      if (questionNumber == _quizData!.length - 1) {
                        showResult = true;
                        updateGameDetails();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminQuizPartyResult(
                                    quizCode: widget.quizCode,
                                  )),
                        );
                      } else {
                        questionNumber++;

                        updateGameDetails();
                      }
                    });
                  },
                )
            
              ],
            )
          ],
        ),
      )),
    );
  }
}
