import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:quiz_app/helper/helper_function.dart';
import 'package:quiz_app/routers/adminRegisterPage.dart';
import 'package:quiz_app/service/auth_service.dart';
import 'package:quiz_app/service/database_service.dart';

import '../widgets/widgets.dart';
import 'adminHomePage.dart';
import 'home.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isloading = false;
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff151a3b),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
            )
          : SingleChildScrollView(
              child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
              child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'images/quiz.png',
                        width: 150, // set the width of the image
                        height: 150, // set the height of the image
                      ),
                      const Center(
                        child: Text(
                          'Quiz App',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 40),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const Center(
                        child: Text(
                          "Login now to create a Quiz",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        onChanged: (emailValue) {
                          setState(() {
                            email = emailValue;
                          });
                        },
                        validator: (emailValue) {
                          return RegExp(
                                      r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)*[a-zA-Z]{2,7}$')
                                  .hasMatch(emailValue!)
                              ? null
                              : "Please enter a valid email";
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1.0)),
                          labelStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                          labelText: "Email",
                          prefixIcon:
                              const Icon(Icons.email, color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        onChanged: (pwlValue) {
                          setState(() {
                            password = pwlValue;
                          });
                        },
                        validator: (pwValue) {
                          if (pwValue!.length < 3) {
                            return "Password must be at least 3 characters";
                          } else {
                            return null;
                          }
                        },
                        obscureText: true,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1.0)),
                          labelStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                          labelText: "Password",
                          prefixIcon:
                              const Icon(Icons.lock, color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xff1D9EA7),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          onPressed: () {
                            logIn();
                          },
                          child: const Center(
                              child: Text(
                            "LogIn",
                            style: TextStyle(fontSize: 18),
                          )),
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Text.rich(TextSpan(
                          text: "You don't have an account? ",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                          children: [
                            TextSpan(
                                text: "Register here",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).primaryColor,
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    //move to register
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const AdminRegisterPage()));
                                  })
                          ])),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(
                                  color: Colors.blueGrey, width: 2),
                            ),
                            primary: const Color(0xff151a3b),
                          ),
                          child: const Text(
                            'Return to Home',
                            style:
                                TextStyle(fontSize: 24, color: Colors.blueGrey),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Home()),
                            );
                          },
                        ),
                      ),
                    ],
                  )),
            )),
    );
  }

  logIn() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isloading = true;
      });
      await authService
          .loginWithEmailAndPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);
          await HelperFunctions.storeUserLoginStatus(true);
          await HelperFunctions.storeUserEmail(email);
          await HelperFunctions.storeUserName(snapshot.docs[0]["fullName"]);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const AdminHomePage()));
        } else {
          setState(() {
            showSnackBar(context, Colors.red, value);
            _isloading = false;
          });
        }
      });
    }
  }
}
