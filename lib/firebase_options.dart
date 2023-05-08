// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDng16W2DT7MPmgcLef8gaJdj5JhpJuNeo',
    appId: '1:520948841027:web:c6b5ba02def6e2ef2df2f6',
    messagingSenderId: '520948841027',
    projectId: 'quizi-appli',
    authDomain: 'quizi-appli.firebaseapp.com',
    databaseURL: 'https://quizi-appli-default-rtdb.firebaseio.com',
    storageBucket: 'quizi-appli.appspot.com',
    measurementId: 'G-LK4B04FWD5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDEviGqHRBUHnnhXWVPaNVJpyDKetElx6U',
    appId: '1:520948841027:android:82ada30e87d920e02df2f6',
    messagingSenderId: '520948841027',
    projectId: 'quizi-appli',
    databaseURL: 'https://quizi-appli-default-rtdb.firebaseio.com',
    storageBucket: 'quizi-appli.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDP2TFaXisHHWRcvlb9-NXb_ia7LQ2gV1U',
    appId: '1:520948841027:ios:32a7384f8429b9f52df2f6',
    messagingSenderId: '520948841027',
    projectId: 'quizi-appli',
    databaseURL: 'https://quizi-appli-default-rtdb.firebaseio.com',
    storageBucket: 'quizi-appli.appspot.com',
    iosClientId: '520948841027-egr6bbuhfne2ee9tpok3kga4vpocglk3.apps.googleusercontent.com',
    iosBundleId: 'com.example.quizApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDP2TFaXisHHWRcvlb9-NXb_ia7LQ2gV1U',
    appId: '1:520948841027:ios:32a7384f8429b9f52df2f6',
    messagingSenderId: '520948841027',
    projectId: 'quizi-appli',
    databaseURL: 'https://quizi-appli-default-rtdb.firebaseio.com',
    storageBucket: 'quizi-appli.appspot.com',
    iosClientId: '520948841027-egr6bbuhfne2ee9tpok3kga4vpocglk3.apps.googleusercontent.com',
    iosBundleId: 'com.example.quizApp',
  );
}