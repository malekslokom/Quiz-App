import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/routers/participateToQuiz.dart';

import 'LoadPage.dart';
import 'home.dart';

class CodePage extends StatelessWidget {
  CodePage({Key? key}) : super(key: key);

  late String quizCode; // Variable to store the quiz code entered by the user

  Future<void> verifyQuizCode(BuildContext context) async {
    final quizSnapshot = await FirebaseFirestore.instance
        .collection('quizzes')
        .where('quizCode', isEqualTo: quizCode)
        .get();

    if (quizSnapshot.docs.isNotEmpty) {
      // Quiz code exists, create a new participant in QuizParty collection
      await FirebaseFirestore.instance.collection('quizParty').add({
        'quizCode': quizCode,
        'participantName': '',
        'startButton': false,
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ParticipateToQuiz(
            quizCode: quizCode,
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Invalid Quiz Code'),
            content:
                const Text('The quiz code is incorrect. Please try again.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
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
      body: 
      Center(
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'images/quiz.png',
                width: 150, // set the width of the image
                height: 150, // set the height of the image
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
                  autofocus: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Quiz code',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    quizCode = value;
                  },
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
                      const Text('Start Quiz', style: TextStyle(fontSize: 24)),
                  onPressed: () {
                    verifyQuizCode(
                        context); // Verify the quiz code and handle participation
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
