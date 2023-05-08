import 'package:flutter/material.dart';

import 'home.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text('AdminHomeScreen Screen'),
    //   ),
    //   body: Center(
    //     child: Column(
    //       children: <Widget>[
    //         Text(
    //           'AdminHomeScreen screen',
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
    return const Scaffold(
      body: Center(child: Text("Home page")),
    );
  }
}
