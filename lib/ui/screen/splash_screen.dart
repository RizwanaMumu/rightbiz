import 'package:animate_do/animate_do.dart';
import 'package:app/Core/viewModel/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Core/services/apis.dart';
import '../../Core/viewModel/shared_pref.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late Tween<double> _tweenSize;
  late Animation<double> _animationSize;
  late AnimationController _animationController;
  String? accessToken;
  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1800));
    _tweenSize = Tween(begin: 0, end: 0.5);
    _animationSize = _tweenSize.animate(_animationController);
    _animationController.forward();
    final dataProvider =
        Provider.of<SharedPrefProvider>(context, listen: false);
    final loginController =
        Provider.of<LoginController>(context, listen: false);
    dataProvider.getToken();

    super.initState();
    Future.delayed(Duration(milliseconds: 2500), () async {
      final pref = await SharedPreferences.getInstance();
      accessToken = pref.getString('accessToken');
      if (accessToken == null) {
        Navigator.pushReplacementNamed(context, 'Sign in');
      } else {
        final result = await Api().checkLogin(accessToken!);
        print(
            "Login Status in Splash Screen : " + result.loginStatus.toString());
        if (result.loginStatus == true) {
          print("Login Status in Splash Screen if : " +
              result.loginStatus.toString());
          Navigator.pushReplacementNamed(context, 'Home');
        } else {
          print("Login Status in Splash Screen else : " +
              result.loginStatus.toString());
          Navigator.pushReplacementNamed(context, 'Sign in');
        }
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
        height: size.height,
        width: size.width,
        color: Color(0xffffffff),
        child: Center(
            child: FadeIn(
          animate: true,
          duration: Duration(milliseconds: 1500),
          child: FadeOut(
            animate: true,
            delay: Duration(milliseconds: 1700),
            duration: Duration(milliseconds: 800),
            child: Image.asset(
              'assets/images/logo_big.png',
              width: 130.w,
            ),
          ),
        )));
  }
}
