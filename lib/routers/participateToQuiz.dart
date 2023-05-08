import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'LoadPage.dart';
import 'home.dart';

class ParticipateToQuiz extends StatefulWidget {
  final String quizCode;
  const ParticipateToQuiz({Key? key, required this.quizCode}) : super(key: key);

  @override
  _ParticipateToQuizState createState() => _ParticipateToQuizState();
}

class _ParticipateToQuizState extends State<ParticipateToQuiz> {
  final TextEditingController fullNameController = TextEditingController();

  void participate(
      BuildContext context, String fullName, String quizCode) async {
    // Check if the quiz with the given code exists
    DocumentSnapshot quizSnapshot = await FirebaseFirestore.instance
        .collection('quizParty')
        .doc(quizCode)
        .get();

    if (quizSnapshot.exists) {
      // Add the participant to the QuizParty collection
      await FirebaseFirestore.instance
          .collection('quizParty')
          .doc(quizCode)
          .update({
        // 'participants': FieldValue.arrayUnion([fullName]),
        // 'questionResponses':
        //     FieldValue.arrayUnion([]), // Initialize with empty response list
        'participants.${fullName}': {
          // 'fullName': fullName,
          'response': FieldValue.arrayUnion([]),
          'timers': FieldValue.arrayUnion([]),
        },
      });
      // Navigate to the LoadPage and pass the quizCode and participant's name
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              LoadPage(quizCode: quizCode, fullName: fullName),
        ),
      );
    } else {
      // Show an error dialog if the quiz with the given code doesn't exist
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Invalid Quiz Code"),
            content: const Text("Please enter a valid quiz code."),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff151a3b),
      body: Center(
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'images/quiz.png',
                width: 150,
                height: 150,
              ),
              const Text(
                'Quiz App',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
              const Text(
                'Learn while playing',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 25,
                ),
                child: TextField(
                  controller: fullNameController,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    primary: const Color(0xff1D9EA7),
                  ),
                  child:
                      const Text('Participate', style: TextStyle(fontSize: 24)),
                  onPressed: () {
                    String fullName = fullNameController.text.trim();
                    String quizCode =
                        widget.quizCode; // Replace with the actual quiz code

                    if (fullName.isNotEmpty) {
                      participate(context, fullName, quizCode);
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Invalid Name"),
                            content: const Text("Please enter your full name."),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("OK"),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.blueGrey, width: 2),
                    ),
                    primary: const Color(0xff151a3b),
                  ),
                  child: const Text(
                    'Return to Home',
                    style: TextStyle(fontSize: 24, color: Colors.blueGrey),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Home()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
