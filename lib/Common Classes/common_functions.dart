import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ui/screen/login_screen.dart';

class CommonFunctions {
  Future<void> launchUrlFunc(Uri _url) async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }

  loader(BuildContext context) {
    showDialog(
        barrierColor: Colors.white54,
        context: context,
        barrierDismissible: false,
        useSafeArea: false,
        builder: (context) => WillPopScope(
              onWillPop: () async => false,
              child: Container(
                width: 50.w,
                height: 50.h,
                child: LoadingAnimationWidget.threeArchedCircle(
                    color: Color(0xff2464B3), size: 35),
              ),
            ));
  }

  sessionExpiry(BuildContext context) {
    loader(context);
    EasyLoading.showToast("Session Expired. Please Login Again.");
    Future.delayed(Duration(milliseconds: 3000), () {
      EasyLoading.dismiss();
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false);
    });
  }
}
