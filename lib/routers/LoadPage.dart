import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'home.dart';
import 'quizPage.dart';

class LoadPage extends StatelessWidget {
  final String quizCode;
  final String fullName;

  const LoadPage({Key? key, required this.quizCode, required this.fullName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("WTFFFF");
    return Scaffold(
      backgroundColor: const Color(0xff151a3b),
      body: Center(
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
            const SizedBox(height: 50),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('quizParty')
                  .doc(quizCode)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  print("HHHHH");
                  return Column(
                    children: const [
                      CircularProgressIndicator(
                        color: Colors.white,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Waiting for the quiz to start...',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  );
                }

                final data = snapshot.data?.data() as Map<String, dynamic>?;
                print(data);
                if (data != null && data['startButton'] == true) {
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => QuizPage(
                              quizCode: quizCode,
                              fullName:
                                  fullName)), //quizCode: quizCode, fullName: fullName
                    ),
                  );
                } else {
                  return Column(
                    children: const [
                      CircularProgressIndicator(
                        color: Colors.white,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Waiting for the quiz to start...',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  );
                }

                return const SizedBox(); // Return an empty SizedBox as a fallback
              },
            ),
          ],
        ),
      ),
    );
  }
}
