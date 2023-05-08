import 'package:flutter/material.dart';
import 'package:quiz_app/routers/codePage.dart';

import 'adminMain.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff151a3b),
        body: Center(
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
                      fontSize: 40),
                ),
                const Text(
                  'Learn while playing',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      top: 30), // set the margin top value
                  // child: ElevatedButton(
                  //   onPressed: () {
                  //     // Define an action for the button here
                  //     print('Code Quiz');
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => const CodePage()),
                  //     );
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: 54, vertical: 10),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //     primary: Color(0xff1D9EA7),
                  //   ),
                  //   child: const Text('Join Quiz',
                  //       style: TextStyle(fontSize: 24)),
                  // )
                  child: SizedBox(
                    width: 240,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xff1D9EA7),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      onPressed: () {
                        print('Code Quiz');
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CodePage()),
                        );
                      },
                      child: const Center(
                          child: Text(
                        "Join Quiz",
                        style: TextStyle(fontSize: 24),
                      )),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      top: 20), // set the margin top value
                  // child: ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: 43, vertical: 10),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //     primary: Color(0xff1D9EA7),
                  //   ),
                  //   child: const Text('Create Quiz',
                  //       style: TextStyle(fontSize: 24)),
                  //   onPressed: () {
                  //     // Define an action for the button here
                  //     print('Create Quiz');
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => const AdminMain()),
                  //     );
                  //   },
                  // )
                  child: SizedBox(
                    width: 240,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xff1D9EA7),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      onPressed: () {
                        print('Create Quiz');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AdminMain()),
                        );
                      },
                      child: const Center(
                          child: Text(
                        "Create Quiz",
                        style: TextStyle(fontSize: 24),
                      )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
