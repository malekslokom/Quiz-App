// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'home.dart';

class UserDashboard extends StatefulWidget {
  final String quizCode;
  final String fullName;

  const UserDashboard({
    Key? key,
    required this.quizCode,
    required this.fullName,
  }) : super(key: key);

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  List<Map<String, dynamic>>? _quizData;
  Map<String, dynamic>? _participantsData;
  @override
  void initState() {
    super.initState();
    _loadQuizSnapshot();
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
      backgroundColor: const Color(0xff151a3b),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Dashboard'),
            SizedBox(width: 8),
            Icon(Icons.dashboard),
          ],
        ),
        //title: Text('Dashboard'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                      border: participant.keys.first == widget.fullName
                          ? Border.all(color: Colors.red)
                          : null,
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
                                  fontWeight:
                                      participant.keys.first == widget.fullName
                                          ? FontWeight.w900
                                          : null),
                            ),
                      title: Text(
                        '${participant.keys.first}',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight:
                                participant.keys.first == widget.fullName
                                    ? FontWeight.w900
                                    : null),
                      ),
                      trailing: Text(
                        '${participant.values.first}',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight:
                                participant.keys.first == widget.fullName
                                    ? FontWeight.w900
                                    : null),
                      ),
                    ));
              },
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 240,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Color(0xff1D9EA7),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                },

                child: const Center(
                    child: Text(
                  "Quiz App",
                  style: TextStyle(fontSize: 24),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
