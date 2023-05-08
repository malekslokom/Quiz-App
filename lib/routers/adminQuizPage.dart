// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class AdminQuizPage extends StatefulWidget {
//   @override
//   _AdminQuizPageState createState() => _AdminQuizPageState();
// }

// class _AdminQuizPageState extends State<AdminQuizPage> {
//   final CollectionReference quizCollection =
//       FirebaseFirestore.instance.collection("quizzes");
//   final List<Map<String, dynamic>> questions = [];
//   late String quizCode = 'quiz123';
//   late String quizTitle = 'My Quiz';
//   Future<void> savingUserQuizzes(String uid, String quizCode, String quizTitle,
//       List<Map<String, dynamic>> questions) async {
//     try {
//       final userCollection = FirebaseFirestore.instance.collection('quizzes');
//       await userCollection.doc(quizCode).set({
//         "quizCode": quizCode,
//         "quizTitle": quizTitle,
//         "questions": questions,
//         "userId": uid,
//       });

//       print('User quizzes saved successfully.');
//     } catch (e) {
//       print('Error saving user quizzes: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             TextField(
//               decoration: const InputDecoration(labelText: 'Quiz title'),
//               onChanged: (value) {
//                 quizTitle = value;
//               },
//             ),
//             TextField(
//               decoration: const InputDecoration(labelText: 'Quiz code'),
//               onChanged: (value) {
//                 quizCode = value;
//               },
//             ),
//             Column(
//               children: questions.map((question) {
//                 final List<Map<String, dynamic>> options = question['options'];

//                 return Column(
//                   children: [
//                     TextField(
//                       decoration: const InputDecoration(labelText: 'Question'),
//                       onChanged: (value) {
//                         question['questionText'] = value;
//                       },
//                     ),
//                     Column(
//                       children: options
//                           .map((option) => ListTile(
//                                 title: Text(option['optionText']),
//                               ))
//                           .toList(),
//                     ),
//                     TextField(
//                       decoration: InputDecoration(labelText: 'Correct answer'),
//                       onChanged: (value) {
//                         question['correctAnswer'] = value;
//                       },
//                     ),
//                     TextField(
//                       decoration: InputDecoration(labelText: 'Option'),
//                       onChanged: (value) {
//                         question['options'].add({'optionText': value});
//                       },
//                     ),
//                     ElevatedButton(
//                       child: Text('Add Option'),
//                       onPressed: () {
//                         setState(() {});
//                       },
//                     ),
//                   ],
//                 );
//               }).toList(),
//             ),
//             ElevatedButton(
//               child: Text('Add Question'),
//               onPressed: () {
//                 setState(() {
//                   questions.add({
//                     'questionText': '',
//                     'correctAnswer': '',
//                     'options': <Map<String, dynamic>>[],
//                   });
//                 });
//               },
//             ),
//             ElevatedButton(
//               child: Text('Save Quizzes'),
//               onPressed: () {
//                 final String uid = 'user123';
//                 // final String quizCode = 'quiz123';
//                 // final String quizTitle = 'My Quiz';

//                 savingUserQuizzes(uid, quizCode, quizTitle, questions);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminQuizPage extends StatefulWidget {
  @override
  _AdminQuizPageState createState() => _AdminQuizPageState();
}

class _AdminQuizPageState extends State<AdminQuizPage> {
  final CollectionReference quizCollection =
      FirebaseFirestore.instance.collection("quizzes");
  final List<Map<String, dynamic>> questions = [];
  late String quizCode = 'quiz123';
  late String quizTitle = 'My Quiz';

  TextEditingController optionController = TextEditingController();

  Future<void> savingUserQuizzes(
    String uid,
    String quizCode,
    String quizTitle,
    List<Map<String, dynamic>> questions,
  ) async {
    try {
      final userCollection = FirebaseFirestore.instance.collection('quizzes');
      await userCollection.doc(quizCode).set({
        "quizCode": quizCode,
        "quizTitle": quizTitle,
        "questions": questions,
        "userId": uid,
      });

      print('User quizzes saved successfully.');
    } catch (e) {
      print('Error saving user quizzes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Quiz title'),
              onChanged: (value) {
                setState(() {
                  quizTitle = value;
                });
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Quiz code'),
              onChanged: (value) {
                setState(() {
                  quizCode = value;
                });
              },
            ),
            Column(
              children: questions.map((question) {
                final List<Map<String, dynamic>> options = question['options'];

                return Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(labelText: 'Question'),
                      onChanged: (value) {
                        setState(() {
                          question['questionText'] = value;
                        });
                      },
                    ),
                    Column(
                      children: options
                          .map(
                            (option) => ListTile(
                              title: Text(option['optionText']),
                            ),
                          )
                          .toList(),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Correct answer'),
                      onChanged: (value) {
                        setState(() {
                          question['correctAnswer'] = value;
                        });
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Option'),
                      controller: optionController,
                      onChanged: (value) {
                        optionController.text = value;
                      },
                    ),
                    ElevatedButton(
                      child: Text('Add Option'),
                      onPressed: () {
                        setState(() {
                          question['options'].add({
                            'optionText': optionController.text,
                          });
                          optionController.clear();
                        });
                      },
                    ),
                  ],
                );
              }).toList(),
            ),
            ElevatedButton(
              child: Text('Add Question'),
              onPressed: () {
                setState(() {
                  questions.add({
                    'questionText': '',
                    'correctAnswer': '',
                    'options': <Map<String, dynamic>>[],
                  });
                });
              },
            ),
            ElevatedButton(
              child: Text('Save Quizzes'),
              onPressed: () {
                final String uid = 'user123';
                savingUserQuizzes(uid, quizCode, quizTitle, questions);
              },
            ),
          ],
        ),
      ),
    );
  }
}
