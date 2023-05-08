import 'package:flutter/material.dart';

import '../helper/helper_function.dart';
import 'adminHomePage.dart';
import 'adminLoginPage.dart';

class AdminMain extends StatefulWidget {
  const AdminMain({Key? key}) : super(key: key);

  @override
  State<AdminMain> createState() => _AdminMainState();
}

class _AdminMainState extends State<AdminMain> {
  bool _isSignedIn = false;
  @override
  void initState() {
    super.initState();
    getUserLoginStatus();
  }

  getUserLoginStatus() async {
    await HelperFunctions.getUserLoginStatus().then((value) => {
          if (value != null)
            {
              setState(() {
                _isSignedIn = value;
              })
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text('AdminMain Screen'),
    //   ),
    //   body: Center(
    //     child: Column(
    //       children: <Widget>[
    //         Text(
    //           'AdminMain screen',
    //           style: Theme.of(context).textTheme.headline6,
    //         ),
    //         ElevatedButton(
    //           child: const Text('Open Home'),
    //           onPressed: () {
    //             // Define an action for the button here
    //             print('Button pressed!');
    //             Navigator.push(
    //               context,
    //               MaterialPageRoute(builder: (context) => new Home()),
    //             );
    //           },
    //         ),
    //       ],
    //     ),
    //   ),
    // );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: _isSignedIn ? const AdminHomePage() : const AdminLoginPage(),
    );
  }
}
