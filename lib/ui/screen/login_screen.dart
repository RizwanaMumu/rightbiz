import 'dart:convert';
import 'dart:io';

import 'package:app/Common%20Classes/app_constants.dart';
import 'package:app/Core/viewModel/login_controller.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:m_toast/m_toast.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../Common Classes/common_functions.dart';
import '../../Core/services/apis.dart';
import '../../Core/viewModel/shared_pref.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late Size size;
  GoogleSignInAccount? _currentUser;
  late GoogleSignIn _googleSignIn;
  bool _isAuthorized = false; // has granted permissions?
  String _contactText = '';
  String email = '';
  String password = '';
  bool _isChecked = false;
  bool _isObsecure = true;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    //checkTestCookie();
    _loadUserEmailPassword();
    super.initState();

    _googleSignIn = GoogleSignIn(
      // Optional clientId
      // clientId: 'your-client_id.apps.googleusercontent.com',
      scopes: UrlConstants.scopes,
    );

    _googleSignIn!.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      // In mobile, being authenticated means being authorized...
      bool isAuthorized = account != null;
      // However, in the web...
      if (kIsWeb && account != null) {
        isAuthorized =
            await _googleSignIn!.canAccessScopes(UrlConstants.scopes);
      }

      setState(() {
        _currentUser = account;
        _isAuthorized = isAuthorized;
      });

      // Now that we know that the user can access the required scopes, the app
      // can call the REST API.
      if (isAuthorized) {
        _handleGetContact(account!);
      }
    });

    // In the web, _googleSignIn.signInSilently() triggers the One Tap UX.
    //
    // It is recommended by Google Identity Services to render both the One Tap UX
    // and the Google Sign In button together to "reduce friction and improve
    // sign-in rates" ([docs](https://developers.google.com/identity/gsi/web/guides/display-button#html)).
    _googleSignIn!.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    /*if (Platform.isIOS) {
      final appleClientID = SignInWithApple.ge;
      print('Apple Client ID: $appleClientID');
    }*/
    size = MediaQuery.of(context).size;
    final controller = Provider.of<LoginController>(context, listen: true);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xff225FAC),
        body: DoubleBackToCloseApp(
          snackBar: SnackBar(
            content: Text('Tap back again to leave'),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: _keyboardIsVisible() ? 40.h : 90.h,
                  child: !_keyboardIsVisible()
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.0.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10.h,
                              ),
                              // Text(
                              //   "Welcome Back!",
                              //   style: TextStyle(
                              //       fontSize: 24.sp,
                              //       color: Colors.white,
                              //       fontWeight: FontWeight.bold),
                              // ),
                              // SizedBox(
                              //   height: 5.h,
                              // ),
                              // Text(
                              //   "Please Sign In to continue",
                              //   style: TextStyle(
                              //       fontSize: 12.sp,
                              //       color: Color(0xffDEDEDE),
                              //       fontWeight: FontWeight.w500,
                              //       letterSpacing: 0.6),
                              // )
                            ],
                          ),
                        )
                      : Container(),
                ),
                Container(
                  width: size.width,
                  height: size.height - 90.h,
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35.r),
                        topRight: Radius.circular(35.r)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 90.h,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Image(
                          image: AssetImage('assets/images/logo_big.png'),
                          fit: BoxFit.contain,
                          width: 155.w,
                        ),
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      Container(
                        height: 30.h,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                width: 1.4, color: Color(0xffE2E2E2)),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: size.width - 150.w,
                              height: 30.h,
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 2.w),
                              child: TextFormField(
                                controller: _emailController,
                                textAlignVertical: TextAlignVertical.center,
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500),
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                  border: InputBorder.none,
                                  hintText: 'Email',
                                  hintStyle: TextStyle(
                                      color: Color(0xff757575),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                                onChanged: (data) {
                                  setState(() {
                                    email = data;
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 25.h,
                      ),
                      Container(
                        height: 30.h,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                width: 1.4, color: Color(0xffE2E2E2)),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: size.width - 150.w,
                              height: 30.h,
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 2.w),
                              child: TextFormField(
                                  obscureText: _isObsecure,
                                  controller: _passwordController,
                                  textAlignVertical: TextAlignVertical.center,
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                    hintText: 'Password',
                                    hintStyle: TextStyle(
                                        color: Color(0xff757575),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  onChanged: (data) {
                                    setState(() {
                                      password = data;
                                    });
                                  }),
                            ),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (_isObsecure) {
                                      _isObsecure = false;
                                    } else {
                                      _isObsecure = true;
                                    }
                                  });
                                },
                                icon: _isObsecure
                                    ? Icon(
                                        Icons.remove_red_eye_rounded,
                                        size: 16.sp,
                                        color: Color(0xff757575),
                                      )
                                    : Icon(
                                        CupertinoIcons.eye_slash_fill,
                                        size: 16.sp,
                                        color: Color(0xff757575),
                                      ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          SizedBox(
                              height: 20.0,
                              width: 20.0,
                              child: Theme(
                                data: ThemeData(
                                    unselectedWidgetColor:
                                        Color(0xff00C8E8) // Your color
                                    ),
                                child: Transform.scale(
                                  scale: 0.7,
                                  child: Checkbox(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(2.r),
                                      ),
                                      side: BorderSide(
                                          color: Color(0xff225FAC), width: 1.2),
                                      activeColor: Color(0xff225FAC),
                                      value: _isChecked,
                                      onChanged: (data) {
                                        setState(() {
                                          _isChecked = data!;
                                        });
                                      }),
                                ),
                              )),
                          SizedBox(width: 10.0),
                          Text("Remember Me",
                              style: TextStyle(
                                  color: Color(0xff225FAC),
                                  fontSize: 13.sp,
                                  fontFamily: 'Rubic'))
                        ],
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: 40.h,
                          width: size.width - 60.w,
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.r)),
                            color: Color(0xff225FAC),
                            onPressed: () {
                              if (_emailController.text == '') {
                                print('text null');
                              }

                              _loginFunc();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 25,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Platform.isIOS
                          ? Align(
                              child: InkWell(
                              onTap: () {
                                final Uri _url = Uri.parse(
                                    'https://www.rightdev.co.uk/member_secure/');
                                CommonFunctions().launchUrlFunc(_url);
                              },
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                    color: Color(0xff181725),
                                    fontWeight: FontWeight.w400),
                              ),
                            ))
                          : SizedBox(),
                      SizedBox(
                        height: 40.h,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: 40.h,
                          width: size.width - 60.w,
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.r)),
                            color: Color(0xff225FAC),
                            onPressed: () async {
                              await controller.getIsLogIn();
                              print("Login or not ${controller.isLoggedIn}");
                              await controller.handleLogin();

                              print("Login Info ${controller.token}");

                              _googleLoginFunc(controller.token!, controller);
                              //print("user info $result");
                              //print("Login Info ${controller.googleAccount.value}");
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/search.png',
                                    width: 22.w),
                                SizedBox(
                                  width: 15.w,
                                ),
                                Text(
                                  "Sign in with Google",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Platform.isIOS
                          ? Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                height: 40.h,
                                width: size.width - 60.w,
                                child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(50.r)),
                                  color: Color(0xff225FAC),
                                  onPressed: () async {


                                    final credential = await SignInWithApple
                                        .getAppleIDCredential(
                                      scopes: [
                                        AppleIDAuthorizationScopes.email,
                                        AppleIDAuthorizationScopes.fullName,
                                      ],
                                    );

                                    print("Apple Login Result ${credential.email}, ${credential.familyName}, ${credential.givenName}, ${credential.state}");
                                    print("Authorization code ${credential.authorizationCode}");
                                    print("Identity Token ${credential.identityToken}");

                                    //decodeAppleIdToken(credential.identityToken!);

                                    _appleLoginFunc(credential.authorizationCode,controller);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                          'assets/images/apple-logo.png',
                                          width: 22.w),
                                      SizedBox(
                                        width: 15.w,
                                      ),
                                      Text(
                                        "Sign in with Apple   ",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void decodeAppleIdToken(String idToken) {
    List<String> tokenSegments = idToken.split('.');

    if (tokenSegments.length != 3) {
      print('Invalid token format');
      return;
    }

    String payload = tokenSegments[1];
    String decodedPayload = utf8.decode(base64Url.decode(payload));

    Map<String, dynamic> tokenData = jsonDecode(decodedPayload);

    // Extract the email from the token data
    String email = tokenData['email'];

    print('Email: $email');
  }

  _loginFunc() async {
    CommonFunctions().loader(context);
    _handleRemeberme();
    print("email ${email} pass ${password}");
    final result = await Api()
        .getUserLogin(_emailController.text, _passwordController.text);
    if (result.loginStatus == true) {
      print(result.loginStatus == true);
      final prefProvider =
          Provider.of<SharedPrefProvider>(context, listen: false);
      prefProvider.setToken(
          result.accessToken!, result.userName!, result.userEmail!);
      String externalUserId = result
          .userId!; // You will supply the external user id to the OneSignal SDK

// Setting External User Id with Callback Available in SDK Version 3.9.3+
      OneSignal.shared.setExternalUserId(externalUserId).then((results) {
        print(results.toString());
      }).catchError((error) {
        print(error.toString());
      });
      ShowMToast toast = ShowMToast();
      toast.successToast(context,
          message: 'Successfully logged in!',
          textColor: Colors.white,
          alignment: Alignment.bottomCenter,
          backgroundColor: Color(0xbb2460ad),
          icon: Icons.check_circle_outline_rounded,
          iconColor: Colors.white);

      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => HomeScreen()));
      });
    } else {
      Navigator.pop(context);
      ShowMToast toast = ShowMToast();
      toast.errorToast(
        context,
        message: result.errors![0].message!,
        //textColor: Colors.white,
        alignment: Alignment.bottomCenter,
        //backgroundColor: Color(0xbb2460ad),
        //icon: Icons.check_circle_outline_rounded,
        //iconColor: Colors.white
      );
    }
  }

  _googleLoginFunc(String token, final controller) async {
    print("Google Social Login Button Clicked ! ");

    CommonFunctions().loader(context);

    final result = await Api().getUserSocialLogin(token);
    if (result.loginStatus == true) {
      print(result.loginStatus == true);
      final prefProvider =
          Provider.of<SharedPrefProvider>(context, listen: false);
      prefProvider.setToken(
          result.accessToken!, result.userName!, result.userEmail!);
      String externalUserId = result
          .userId!; // You will supply the external user id to the OneSignal SDK

// Setting External User Id with Callback Available in SDK Version 3.9.3+
      OneSignal.shared.setExternalUserId(externalUserId).then((results) {
        print(results.toString());
      }).catchError((error) {
        print(error.toString());
      });
      ShowMToast toast = ShowMToast();
      toast.successToast(context,
          message: 'Successfully logged in!',
          textColor: Colors.white,
          alignment: Alignment.bottomCenter,
          backgroundColor: Color(0xbb2460ad),
          icon: Icons.check_circle_outline_rounded,
          iconColor: Colors.white);

      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => HomeScreen()));
      });
    } else {
      controller.googleSignIn.disconnect();
      Navigator.pop(context);
      ShowMToast toast = ShowMToast();
      toast.errorToast(
        context,
        message: result.message!,
        alignment: Alignment.bottomCenter,
      );
    }
  }

  _appleLoginFunc(String token, final controller) async {
    print("Google Social Login Button Clicked ! ");

    CommonFunctions().loader(context);

    final result = await Api().getUserSocialAppleLogin(token);
    if (result.loginStatus == true) {
      print(result.loginStatus == true);
      final prefProvider =
          Provider.of<SharedPrefProvider>(context, listen: false);
      prefProvider.setToken(
          result.accessToken!, result.userName!, result.userEmail!);
      String externalUserId = result
          .userId!; // You will supply the external user id to the OneSignal SDK

// Setting External User Id with Callback Available in SDK Version 3.9.3+
      OneSignal.shared.setExternalUserId(externalUserId).then((results) {
        print(results.toString());
      }).catchError((error) {
        print(error.toString());
      });
      ShowMToast toast = ShowMToast();
      toast.successToast(context,
          message: 'Successfully logged in!',
          textColor: Colors.white,
          alignment: Alignment.bottomCenter,
          backgroundColor: Color(0xbb2460ad),
          icon: Icons.check_circle_outline_rounded,
          iconColor: Colors.white);

      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => HomeScreen()));
      });
    } else {
      controller.googleSignIn.disconnect();
      Navigator.pop(context);
      ShowMToast toast = ShowMToast();
      toast.errorToast(
        context,
        message: result.message!,
        alignment: Alignment.bottomCenter,
      );
    }
  }

  void _handleRemeberme() {
    SharedPreferences.getInstance().then(
      (prefs) {
        if (_isChecked) {
          prefs.setBool("remember_me", _isChecked);
          prefs.setString('email', _emailController.text);
          prefs.setString('password', _passwordController.text);
        } else {
          prefs.setBool("remember_me", _isChecked);
          prefs.setString('email', '');
          prefs.setString('password', '');
        }
      },
    );
  }

  bool _keyboardIsVisible() {
    return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
  }

  void _loadUserEmailPassword() async {
    print("Load Email");
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _email = _prefs.getString("email") ?? "";
      var _password = _prefs.getString("password") ?? "";
      var _remeberMe = _prefs.getBool("remember_me") ?? false;

      print(_remeberMe);
      print(_email);
      print(_password);
      if (_remeberMe) {
        setState(() {
          _isChecked = true;
        });
        _emailController.text = _email ?? "";
        _passwordController.text = _password ?? "";
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    setState(() {
      _contactText = 'Loading contact info...';
    });
    final http.Response response = await http.get(
      Uri.parse('https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names'),
      headers: await user.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = 'People API gave a ${response.statusCode} '
            'response. Check logs for details.';
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data =
        json.decode(response.body) as Map<String, dynamic>;
    final String? namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        _contactText = 'I see you know $namedContact!';
      } else {
        _contactText = 'No contacts to display.';
      }
    });

    print("Contact text " + _contactText);
  }

  String? _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic>? connections = data['connections'] as List<dynamic>?;
    final Map<String, dynamic>? contact = connections?.firstWhere(
      (dynamic contact) => (contact as Map<Object?, dynamic>)['names'] != null,
      orElse: () => null,
    ) as Map<String, dynamic>?;
    if (contact != null) {
      final List<dynamic> names = contact['names'] as List<dynamic>;
      final Map<String, dynamic>? name = names.firstWhere(
        (dynamic name) =>
            (name as Map<Object?, dynamic>)['displayName'] != null,
        orElse: () => null,
      ) as Map<String, dynamic>?;
      if (name != null) {
        return name['displayName'] as String?;
      }
    }
    return null;
  }
}
