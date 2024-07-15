import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefProvider extends ChangeNotifier{
  String accessToken = '';
  String userName = '';
  String userEmail = '';
  getToken() async {
    final prefs = await SharedPreferences.getInstance();
    var result = prefs.getString('accessToken');
    if (kDebugMode) {
      print("Access Token ${result}");
    }
    if (result != null) {
      if (kDebugMode) {
        print(" In Get access Token Function First IF");
      }
      accessToken = result!;
      userName= prefs.getString('userName')!;
      userEmail = prefs.getString('userEmail')!;
    }
    notifyListeners();
  }
  setToken(String token, String name, String email) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('accessToken', token);
    prefs.setString('userName', name);
    prefs.setString('userEmail', email);
    if (kDebugMode) {
      print("Access Token ${token}");
    }
    accessToken = token;
    userEmail = email;
    userName = name;

    notifyListeners();
  }
}