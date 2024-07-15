import 'package:app/Core/viewModel/login_controller.dart';
import 'package:app/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';

import 'Core/viewModel/shared_pref.dart';
import 'Core/viewModel/view_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Upgrader.clearSavedSettings();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  OneSignal.shared.setAppId("3ade43c5-741c-4709-a906-821bec632cc2");

// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>ViewProvider()),
        ChangeNotifierProvider(create: (_)=>SharedPrefProvider()),
        ChangeNotifierProvider(create: (_)=>LoginController()),
      ],
      child: ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
              builder: EasyLoading.init(),
              debugShowCheckedModeBanner: false,
              initialRoute: 'Splash Screen',
              onGenerateRoute: RouteGenerate.generateRoute,
            );
          }),
    );
  }
}
