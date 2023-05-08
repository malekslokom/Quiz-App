import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/helper/helper_function.dart';
import 'package:quiz_app/service/database_service.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //login
  Future loginWithEmailAndPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;
      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      return e;
    }
  }

  //register
  Future registerWithEmailAndPassword(
      String fullName, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;
      if (user != null) {
        await DatabaseService(uid: user.uid).savingUserData(fullName, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      return e;
    }
  }
  //logout

  Future signOut() async {
    try {
      await HelperFunctions.storeUserEmail("");
      await HelperFunctions.storeUserLoginStatus(false);
      await HelperFunctions.storeUserName("");
      await firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      print(e);
      return e;
    }
  }
}
