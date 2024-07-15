import 'package:app/ui/screen/login_screen.dart';
import 'package:app/ui/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'ui/screen/home_screen.dart';

class RouteGenerate {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'Splash Screen':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case 'Sign in':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case 'Home':
        return MaterialPageRoute(builder: (_) => HomeScreen());

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
