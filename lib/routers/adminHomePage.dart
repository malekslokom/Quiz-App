import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/helper/helper_function.dart';
import 'package:quiz_app/routers/adminProfilePage.dart';
import 'package:quiz_app/routers/home.dart';
import 'package:quiz_app/service/database_service.dart';

import '../service/auth_service.dart';
// ignore: unused_import
// ignore: unused_import
import 'adminGamePage.dart';
import 'adminQuizPage.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  AuthService authService = AuthService();
  String userName = "";
  String email = "";
  Stream? quizzes;
  bool _isloading = false;
  String quizName = "";
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

    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserQuizzes()
        .then((snapshot) {
      setState(() {
        quizzes = snapshot;
      });
    });
  }

  String getQuizId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getQuizName(String res) {
    return res.substring(0, res.indexOf("_") + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // body: Center(
        //   child: ElevatedButton(
        //       onPressed: () {
        //         authService.signOut();
        //       },
        //       child: Text("SignOut")),
        // ),
        backgroundColor: Color(0xff151a3b),
        appBar: AppBar(
          actions: [
            InkWell(
              onTap: () {},
              child: Icon(Icons.search),
            )
          ],
          centerTitle: true,
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text(
            "Quizzes",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 27),
          ),
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
                onTap: () {},
                selectedColor: Theme.of(context).primaryColor,
                selected: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                leading: const Icon(
                  Icons.quiz,
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
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const AdminQamePage()));
                },
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                leading: const Icon(
                  Icons.quiz,
                  color: Colors.white,
                ),
                title: const Text(
                  "Guiz Party",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AdminProfilePage()));
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
                          title: const Text(
                            "Logout",
                          ),
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
                                )),
                            IconButton(
                                onPressed: () async {
                                  await authService.signOut();
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => const Home()),
                                      (route) => false);
                                },
                                icon: const Icon(
                                  Icons.done,
                                  color: Colors.green,
                                ))
                          ],
                        );
                      });
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
              )
            ],
          ),
        ),
        body: AdminQuizPage()
        //quizList(),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     //popUpDialog(context);

        //     Navigator.of(context).push(
        //         MaterialPageRoute(builder: (context) => const AdminQuizCreate()));
        //   },
        //   elevation: 0,
        //   backgroundColor: Theme.of(context).primaryColor,
        //   child: const Icon(Icons.add),
        // ),
        );
  }

  // popUpDialog(BuildContext context) {
  //   showDialog(
  //       context: context,
  //       barrierDismissible: false, //nenzed l bara yetsaker
  //       builder: (context) {
  //         return StatefulBuilder(builder: (context, setState) {
  //           return AlertDialog(
  //             title: const Text(" Create a quiz", textAlign: TextAlign.left),
  //             content: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 _isloading
  //                     ? Center(
  //                         child: CircularProgressIndicator(
  //                         color: Theme.of(context).primaryColor,
  //                       ))
  //                     : TextField(
  //                         onChanged: (val) {
  //                           setState(
  //                             () {
  //                               quizName = val;
  //                             },
  //                           );
  //                         },
  //                       )
  //               ],
  //             ),
  //           );
  //         });
  //       });
  // }

  // quizList() {
  //   // Flutter widget that allows you to build your user interface based on the contents of a stream.
  //   // It's commonly used to update the UI in response to changes in real-time data sources
  //   return StreamBuilder(
  //       stream: quizzes,
  //       builder: (context, AsyncSnapshot snapshot) {
  //         if (snapshot.hasData) {
  //           if (snapshot.data["quizzes"] != null) {
  //             if (snapshot.data["quizzes"].length > 0) {
  //               return ListView.builder(
  //                   itemCount: snapshot.data["quizzes"].length,
  //                   itemBuilder: (context, index) {
  //                     int reverseIndex =
  //                         snapshot.data["quizzes"].length - index - 1;
  //                     return QuizTile(
  //                       quizId:
  //                           getQuizId(snapshot.data['quizzes'][reverseIndex]),
  //                       userName: snapshot.data['fullName'],
  //                       quizName:
  //                           getQuizName(snapshot.data['quizzes'][reverseIndex]),
  //                       questions: snapshot.data['questions'],
  //                       creationDate: snapshot.data['creationDate'].toDate(),
  //                     );
  //                   });
  //             } else {
  //               return noQuizWidget();
  //             }
  //           } else {
  //             return noQuizWidget();
  //           }
  //         } else {
  //           return Center(
  //             child: CircularProgressIndicator(
  //               color: Theme.of(context).primaryColor,
  //             ),
  //           );
  //         }
  //       });
  // }

  // noQuizWidget() {
  //   return Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
  //       child: Column(
  //         children: [
  //           InkWell(
  //             child: const Icon(Icons.add, size: 35, color: Colors.white),
  //             onTap: () {
  //               // popUpDialog(context);
  //               Navigator.of(context).push(MaterialPageRoute(
  //                   builder: (context) => const AdminQuizCreate()));
  //             },
  //           ),
  //           const SizedBox(
  //             height: 50,
  //           ),
  //           const Text(
  //             "You have not create any quizzes",
  //             style: TextStyle(
  //               fontSize: 17,
  //               fontWeight: FontWeight.w800,
  //               color: Colors.white,
  //             ),
  //           )
  //         ],
  //       ));
  // }
}
