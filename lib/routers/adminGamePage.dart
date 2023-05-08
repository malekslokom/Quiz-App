// import 'package:flutter/material.dart';
// import 'package:quiz_app/routers/adminHomePage.dart';
// import '../helper/helper_function.dart';
// import '../service/auth_service.dart';
// import 'LoadPage.dart';
// import 'home.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class AdminQamePage extends StatefulWidget {
//   const AdminQamePage({Key? key}) : super(key: key);

//   @override
//   State<AdminQamePage> createState() => _AdminQamePageState();
// }

// class _AdminQamePageState extends State<AdminQamePage> {
//   AuthService authService = AuthService();
//   String userName = "";
//   String email = "";
//   String quizCode = "";

//   @override
//   void initState() {
//     super.initState();
//     getUserData();
//   }

//   getUserData() async {
//     await HelperFunctions.getUserEmail().then((value) {
//       setState(() {
//         email = value!;
//       });
//     });
//     await HelperFunctions.getUserName().then((value) {
//       setState(() {
//         userName = value!;
//       });
//     });
//   }

//   void createRoom() async {
//     // Verify if the quiz code exists in the database
//     bool isQuizCodeValid = await verifyQuizCode(quizCode);

//     if (isQuizCodeValid) {
//       // Create a new room in the database
//       await saveRoomToDatabase();

//       // Navigate to the load page or dashboard
//       // Navigator.push(
//       //   context,
//       //   MaterialPageRoute(builder: (context) => const LoadPage()),
//       // );
//     } else {
//       // Display an error message or show an alert dialog
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text("Invalid Quiz Code"),
//             content: const Text("The entered quiz code is invalid."),
//             actions: <Widget>[
//               TextButton(
//                 child: const Text("OK"),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }

//   Future<bool> verifyQuizCode(String quizCode) async {
//     // Query the database to check if the quiz code exists
//     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//         .collection('quizzes')
//         .where('quizCode', isEqualTo: quizCode)
//         .limit(1)
//         .get();

//     return querySnapshot.docs.isNotEmpty;
//   }

//   Future<void> saveRoomToDatabase() async {
//     // Save the room details to the database
//     try {
//       final userCollection = FirebaseFirestore.instance.collection('rooms');

//       await userCollection.add({
//         "quizCode": quizCode,
//         "startButton": false,
//         "questionNumber": 0,
//         "playerResults": {},
//       });

//       print('Room created successfully.');
//     } catch (e) {
//       print('Error creating room: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xff151a3b),
//       appBar: AppBar(
//         elevation: 0,
//         title: const Text(
//           "Quiz Party",
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 27,
//             color: Colors.white,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Theme.of(context).primaryColor,
//       ),
//       drawer: Drawer(
//         backgroundColor: Color(0xff151a3b),
//         child: ListView(
//           padding: const EdgeInsets.symmetric(vertical: 50),
//           children: [
//             const Icon(
//               Icons.account_circle,
//               size: 150,
//               color: Colors.white,
//             ),
//             const SizedBox(
//               height: 18,
//             ),
//             Text(
//               userName,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//                 fontSize: 18,
//               ),
//             ),
//             const SizedBox(
//               height: 30,
//             ),
//             const Divider(
//               height: 2,
//               color: Colors.white,
//             ),
//             ListTile(
//               onTap: () {
//                 Navigator.of(context).pushReplacement(MaterialPageRoute(
//                     builder: (context) => const AdminHomePage()));
//               },
//               contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//               leading: const Icon(
//                 Icons.quiz,
//                 color: Colors.white,
//               ),
//               title: const Text(
//                 "Quizzes",
//                 style: TextStyle(
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//             ListTile(
//               onTap: () {
//                 Navigator.pop(context);
//               },
//               selectedColor: Theme.of(context).primaryColor,
//               selected: true,
//               contentPadding:
//                   const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//               leading: const Icon(
//                 Icons.quiz,
//               ),
//               title: const Text(
//                 "Quiz Party",
//                 style: TextStyle(),
//               ),
//             ),
//             ListTile(
//               onTap: () {
//                 Navigator.pop(context);
//               },
//               contentPadding:
//                   const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//               leading: const Icon(
//                 Icons.person,
//                 color: Colors.white,
//               ),
//               title: const Text(
//                 "Profile",
//                 style: TextStyle(
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//             ListTile(
//               onTap: () async {
//                 showDialog(
//                   barrierDismissible: false,
//                   context: context,
//                   builder: (context) {
//                     return AlertDialog(
//                       title: const Text("Logout"),
//                       content: const Text("Are you sure you want to logout?"),
//                       actions: [
//                         IconButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                           icon: const Icon(
//                             Icons.cancel,
//                             color: Colors.red,
//                           ),
//                         ),
//                         IconButton(
//                           onPressed: () async {
//                             await authService.signOut();
//                             Navigator.of(context).pushAndRemoveUntil(
//                               MaterialPageRoute(
//                                 builder: (context) => const Home(),
//                               ),
//                               (route) => false,
//                             );
//                           },
//                           icon: const Icon(
//                             Icons.done,
//                             color: Colors.green,
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               },
//               contentPadding:
//                   const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//               leading: const Icon(
//                 Icons.exit_to_app,
//                 color: Colors.white,
//               ),
//               title: const Text(
//                 "Logout",
//                 style: TextStyle(
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 100),
//         width: double.infinity,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Container(
//               margin: const EdgeInsets.only(top: 25),
//               child: const TextField(
//                 autofocus: true,
//                 style: TextStyle(color: Colors.white),
//                 decoration: InputDecoration(
//                   labelText: 'Quiz code',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Container(
//               margin: const EdgeInsets.only(top: 20),
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   primary: Color(0xff1D9EA7),
//                 ),
//                 child: const Text(
//                   'Create Room',
//                   style: TextStyle(fontSize: 24),
//                 ),
//                 onPressed: () {
//                   // Verify the quiz code here
//                   String quizCode =
//                       ""; // Retrieve the quiz code from the TextField

//                   // Add your verification logic here
//                   // Example: Query the database to check if the quiz code exists
//                   bool quizCodeExists =
//                       true; // Replace this with your actual verification result

//                   if (quizCodeExists) {
//                     // Create a new room in the database
//                     // Add the players' names and initialize the start button to false
//                     // Perform any other necessary operations

//                     // Redirect to the LoadPage or the dashboard for the created room
//                     // Navigator.push(
//                     //   context,
//                     //   MaterialPageRoute(builder: (context) => LoadPage()),
//                     // );
//                     // ignore: dead_code
//                   } else {
//                     // Display an error message or show a dialog indicating that the quiz code is incorrect
//                     showDialog(
//                       context: context,
//                       builder: (context) {
//                         return AlertDialog(
//                           title: const Text("Invalid Quiz Code"),
//                           content: const Text(
//                               "The quiz code is incorrect. Please try again."),
//                           actions: [
//                             ElevatedButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               child: const Text("OK"),
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                   }
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:quiz_app/routers/adminHomePage.dart';
import 'package:quiz_app/routers/adminQuizPageDetailsQst.dart';
import '../helper/helper_function.dart';
import '../service/auth_service.dart';
import 'LoadPage.dart';
import 'adminGamePageDetails.dart';
import 'home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminQamePage extends StatefulWidget {
  const AdminQamePage({Key? key}) : super(key: key);

  @override
  State<AdminQamePage> createState() => _AdminQamePageState();
}

class _AdminQamePageState extends State<AdminQamePage> {
  AuthService authService = AuthService();
  String userName = "";
  String email = "";
  String quizCode = "";

  @override
  void initState() {
    super.initState();
    getUserData();
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

  void createRoom() async {
    // Verify if the quiz code exists in the database
    bool isQuizCodeValid = await verifyQuizCode(quizCode);

    if (isQuizCodeValid) {
      // Create a new room in the database
      await saveRoomToDatabase();

      // Navigate to the load page or dashboard
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AdminGamePageDetails(quizCode: quizCode)),
      );
    } else {
      // Display an error message or show an alert dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Invalid Quiz Code"),
            content: const Text("The entered quiz code is invalid."),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<bool> verifyQuizCode(String quizCode) async {
    print(email);
    // Query the database to check if the quiz code exists
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        //.where('quizCode', isEqualTo: quizCode)
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    List adminQuizzes = querySnapshot.docs[0]["quizzes"];
    return adminQuizzes.contains(quizCode);
  }

  Future<void> saveRoomToDatabase() async {
    // Save the room details to the database
    try {
      final userCollection = FirebaseFirestore.instance.collection('quizParty');

      await userCollection.doc(quizCode).set({
        "quizCode": quizCode,
        "startButton": false,
        "questionNumber": 0,
        "participants": {},
        "showResult": false,
      });

      print('Room created successfully.');
    } catch (e) {
      print('Error creating room: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 100),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 25),
              child: TextField(
                autofocus: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Quiz code',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    quizCode = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  primary: Color(0xff1D9EA7),
                ),
                child: const Text(
                  'Create Room',
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: () {
                  createRoom();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
