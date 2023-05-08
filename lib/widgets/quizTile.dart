import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class QuizTile extends StatefulWidget {
  final String userName;
  final String quizId;
  final String quizName;
  final Timestamp creationDate;
  final List<Map<String, dynamic>> questions;

  const QuizTile({
    Key? key,
    required this.userName,
    required this.quizId,
    required this.quizName,
    required this.questions,
    required this.creationDate,
  }) : super(key: key);

  @override
  State<QuizTile> createState() => _QuizTileState();
}

class _QuizTileState extends State<QuizTile> {
  @override
  Widget build(BuildContext context) {
    // widget is used to detect and handle gestures, such as taps, swipes, and drags, on the screen.
    // It wraps its child widget and provides callbacks for various gestures.
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: ListTile(
          title: Text(
            widget.quizName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'Quiz Creation Date: ${widget.creationDate.toDate().toString()}',
            style: const TextStyle(fontSize: 13),
          ),
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              widget.quizName.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}
