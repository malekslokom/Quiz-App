import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//contient des méthodes statiques pour faciliter le stockage et la récupération de données
class HelperFunctions {
  //Keys
  //clés statiques utilisées pour stocker et récupérer des données spécifiques
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";

  //Store data
  static Future<bool> storeUserLoginStatus(bool isLogin) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return await sp.setBool(userLoggedInKey,
        isLogin); //stocker la valeur de isLogin avec la clé userLoggedInKey.
  }

  static Future<bool> storeUserName(String userName) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return await sp.setString(userNameKey, userName);
  }

  static Future<bool> storeUserEmail(String userEmail) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return await sp.setString(userEmailKey, userEmail);
  }

  //Read data
  static Future<bool?> getUserLoginStatus() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getBool(userLoggedInKey);
  }

  static Future<String?> getUserName() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(userNameKey);
  }

  static Future<String?> getUserEmail() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(userEmailKey);
  }
}
