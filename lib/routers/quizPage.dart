import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/routers/LoadPage.dart';

import '../widgets/widgets.dart';
import 'adminQuizPageDetailsQst.dart';
import 'userDashboard.dart';

class QuizPage extends StatefulWidget {
  final String quizCode;
  final String fullName;

  const QuizPage({Key? key, required this.quizCode, required this.fullName})
      : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _selectedOptionIndex = -1;
  bool _isButtonDisabled = false;
  int _secondsLeft = 30;
  List<Map<String, dynamic>>? _quizData;
  int _currentQuestionIndex = 0;
  List<int> responses = [];
  List<int> timers = [];
  bool _timesOut = false;
  bool _showResult = false;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    _fetchQuizData();
    _startTimer();
    _listenToQuestionNumber();
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (Timer timer) {
      setState(() {
        if (_secondsLeft < 1) {
          _timesOut = true;
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
                  color: Colors.green,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Correct Answer: ${_quizData![_currentQuestionIndex]["options"][_quizData![_currentQuestionIndex]['correctAnswer']]["optionText"]}',
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

  Future<void> _fetchQuizData() async {
    try {
      final quizPartyDoc = await FirebaseFirestore.instance
          .collection('quizParty')
          .doc(widget.quizCode)
          .get();

      if (quizPartyDoc.exists) {
        final questionNumber = quizPartyDoc.data()?['questionNumber'];
        final quizzesDoc = await FirebaseFirestore.instance
            .collection('quizzes')
            .doc(widget.quizCode)
            .get();

        if (quizzesDoc.exists) {
          final quizData = quizzesDoc.data();
          if (quizData != null && quizData['questions'] is List) {
            final questions =
                List<Map<String, dynamic>>.from(quizData['questions']);
            if (questionNumber >= 0 && questionNumber < questions.length) {
              setState(() {
                _currentQuestionIndex = questionNumber;
                _quizData = questions;
                print(_quizData);
              });
            }
          }
        }
      }
    } catch (e) {
      print('Error fetching quiz data: $e');
    }
  }

  void _listenToQuestionNumber() {
    FirebaseFirestore.instance
        .collection('quizParty')
        .doc(widget.quizCode)
        .snapshots()
        .listen((docSnapshot) {
      final questionNumber = docSnapshot.data()?['questionNumber'];
      final showResult = docSnapshot.data()?['showResult'];

      if (questionNumber != null && questionNumber != _currentQuestionIndex) {
        setState(() {
          _currentQuestionIndex = questionNumber;
          _timesOut = false;
          _isButtonDisabled = false;
        });
      }

      if (showResult != null && showResult == true) {
        setState(() {
          timer.cancel();
          _showResult = true;
        });
      }
    });
  }

  void _handleOptionSelection(int? index) {
    setState(() {
      _selectedOptionIndex = index!;
      _isButtonDisabled = false;
    });
  }

  void _handleNextQuestion() {
    if (_currentQuestionIndex + 1 < _quizData!.length) {
      setState(() {
        responses.add(_selectedOptionIndex);
        timers.add(_secondsLeft);
        if (_secondsLeft > 1) {
          _isButtonDisabled = true;
        } else {
          _selectedOptionIndex = -1;
          _isButtonDisabled = false;
          _secondsLeft = 30;
        }
      });
    } else {
      // Handle end of quiz
      print('End of Quiz');
      setState(() {
        responses.add(_selectedOptionIndex);
        timers.add(_secondsLeft);
        if (_secondsLeft > 1) {
          _isButtonDisabled = true;
        } else {
          _isButtonDisabled = false;
          _secondsLeft = 30;
        }
      });

      if (_secondsLeft == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserDashboard(
                quizCode: widget.quizCode, fullName: widget.fullName),
          ),
        );
      }
    }
    _saveUserResponses();
  }

  void _calculateScore() {
    int score = 0;
    for (int i = 0; i < responses.length; i++) {
      int correctAnswerIndex = _quizData![i]['correctAnswerIndex'];
      if (responses[i] == correctAnswerIndex) {
        score++;
      }
    }

    print('Score: $score');
  }

  void _saveUserResponses() async {
    try {
      final quizPartyRef = FirebaseFirestore.instance
          .collection('quizParty')
          .doc(widget.quizCode);
      final quizPartyDoc = await quizPartyRef.get();

      if (quizPartyDoc.exists) {
        try {
          final participants = quizPartyDoc.data()?['participants'];
          if (participants != null && participants[widget.fullName] != null) {
            final currentResponses =
                participants[widget.fullName]['response'] ?? [];
            final currentTimers = participants[widget.fullName]['timers'] ?? [];

            currentResponses.addAll(responses);
            currentTimers.addAll(timers);

            await quizPartyRef.update({
              'participants.${widget.fullName}.response': currentResponses,
              'participants.${widget.fullName}.timers': currentTimers,
            });
          }
        } catch (e) {
          print('Error updating participant response: $e');
        }
      } else {
        await quizPartyRef.set({
          'participants': {
            widget.fullName: {
              'response': responses,
              'timers': timers,
            },
          },
        });
      }
    } catch (e) {
      print('Error saving user responses: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showResult) {
      return UserDashboard(
        quizCode: widget.quizCode,
        fullName: widget.fullName,
      );
    }

    if (_quizData == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final currentQuestion = _quizData![_currentQuestionIndex];
    print(currentQuestion);
    return Scaffold(
      backgroundColor: const Color(0xff151a3b),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Quiz Page'),
            SizedBox(width: 8),
            Icon(Icons.quiz),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${_currentQuestionIndex + 1}:',
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
                  final option =
                      currentQuestion['options'][index]['optionText'];

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
                        groupValue: _selectedOptionIndex,
                        onChanged: (value) {
                          setState(() {
                            _selectedOptionIndex = value!;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AbsorbPointer(
                    absorbing: _isButtonDisabled,
                    child: ElevatedButton(
                      onPressed: _isButtonDisabled ? null : _handleNextQuestion,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        primary: Color(0xff1D9EA7),
                      ),
                      child: Text(
                        _currentQuestionIndex + 1 < _quizData!.length
                            ? 'Next'
                            : 'Finish Quiz',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(int index, String title) {
    print(title);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xff1D9EA7),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Theme(
        data: ThemeData(
          unselectedWidgetColor: Colors.white,
        ),
        child: RadioListTile(
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          activeColor: const Color(0xff1D9EA7),
          value: index,
          groupValue: _selectedOptionIndex,
          onChanged: _handleOptionSelection,
        ),
      ),
    );
  }
}
