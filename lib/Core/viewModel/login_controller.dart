import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends ChangeNotifier{
  static const List<String> scopes = <String>[
    'openid',
    'profile',
  ];
  var googleSignIn = GoogleSignIn(scopes : scopes);
  GoogleSignInAccount? googleAccount;

  String? token = '';

  bool isLoggedIn = false;

  handleLogin()async{
    googleAccount = await googleSignIn.signIn( );
    GoogleSignInAuthentication googleAuth = await googleAccount!.authentication;
    getAuthToken(googleAuth.accessToken);
    print("Login Info ${googleAuth.accessToken}");
    notifyListeners();
  }

  getAuthToken(String? tken){
    token = tken;
    notifyListeners();
  }

  getIsLogIn()async{
    isLoggedIn = await googleSignIn.isSignedIn();

    notifyListeners();
  }
}