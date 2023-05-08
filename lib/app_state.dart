import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  //peut notifier les widgets de tout changement d'état.
  ApplicationState() {
    init(); //initialiser Firebase
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions
            .currentPlatform); //pour initialiser Firebase avec les options spécifiées dans firebase_options.dart

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]); //FirebaseUI est configuré pour prendre en charge l'authentification par e-mail uniquement en appelant FirebaseUIAuth.configureProviders().

    FirebaseAuth.instance.userChanges().listen((user) {
      //utilisée pour surveiller les modifications de l'utilisateur. Si un utilisateur est connecté, _loggedIn est défini sur true et notifyListeners() est appelé pour informer les widgets écoutant de ce changement d'état.
      if (user != null) {
        _loggedIn = true;
      } else {
        _loggedIn = false;
      }
      notifyListeners();
    });
  }
}
