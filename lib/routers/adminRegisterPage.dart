import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/helper/helper_function.dart';
import 'package:quiz_app/routers/adminHomePage.dart';
import 'package:quiz_app/service/auth_service.dart';

import '../widgets/widgets.dart';

class AdminRegisterPage extends StatefulWidget {
  const AdminRegisterPage({super.key});

  @override
  State<AdminRegisterPage> createState() => _AdminRegisterPageState();
}

class _AdminRegisterPageState extends State<AdminRegisterPage> {
  bool _isloading = false;
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullName = "";
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
                        onChanged: (fullNameValue) {
                          setState(() {
                            fullName = fullNameValue;
                          });
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
                          labelText: "FullName",
                          prefixIcon:
                              const Icon(Icons.person, color: Colors.white),
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
                            register();
                          },
                          child: const Center(
                              child: Text(
                            "Register",
                            style: TextStyle(fontSize: 18),
                          )),
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Text.rich(TextSpan(
                          text: "Already have an account? ",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                          children: [
                            TextSpan(
                                text: "LogIn Now",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).primaryColor,
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    //move to register
                                    Navigator.pop(context);
                                  })
                          ]))
                    ],
                  )),
            )),
    );
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isloading = true;
      });
      await authService
          .registerWithEmailAndPassword(fullName, email, password)
          .then((value) async {
        if (value == true) {
          await HelperFunctions.storeUserLoginStatus(true);
          await HelperFunctions.storeUserEmail(email);
          await HelperFunctions.storeUserName(fullName);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const AdminHomePage()));
        } else {
          showSnackBar(context, Colors.red, value);
          setState(() {
            _isloading = false;
          });
        }
      });
    }
  }
}
