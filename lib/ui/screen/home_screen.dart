import 'dart:io';
import 'package:app/ui/screen/message_details_new.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:m_toast/m_toast.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';
import '../../Common Classes/common_functions.dart';
import '../../Core/model/chatbox_messages.dart';
import '../../Core/model/get_message_model.dart';
import '../../Core/model/upgrade_message.dart';
import '../../Core/services/apis.dart';
import '../../Core/viewModel/shared_pref.dart';
import 'login_screen.dart';
import 'message_details.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> drawerScaffoldKey = GlobalKey<ScaffoldState>();
  late Size size;
  GetMessageModel? messageModel;
  List<ChatboxMessage?> chatboxMessage = [];
  bool _isDataLoaded = false;
  bool _isNextDataLoading = false;
  String _accessToken = '';

  ScrollController _scrollController = ScrollController();
  int currentPage = 1;
  var prefProvider;

  getInitialMessages() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      _accessToken = pref.getString('accessToken')!;
    });
    CommonFunctions().loader(context);
    final result = await Api().getMessengerList(_accessToken, currentPage);
    _checkSession();

    if (result!.status == 'SUCCESS' || result!.status == 'NO_MESSAGE') {
      setState(() {
        messageModel = result;
        _isDataLoaded = true;
        //_isNextDataLoading = false;
        Navigator.pop(context);
      });
    }
  }
/////////
  _checkSession() {
    if (checkSessionExpiry == true) {
      CommonFunctions().sessionExpiry(context);
    }
  }

  getMessages() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      _accessToken = pref.getString('accessToken')!;
    });
    // CommonFunctions().loader(context);
    final result = await Api().getMessengerList(_accessToken, currentPage);
    _checkSession();

    if (result!.status == 'SUCCESS') {
      setState(() {
        result!.data!.forEach((element) {
          messageModel?.data?.add(element);
        });
        _isNextDataLoading = false;
        // Navigator.pop(context);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getInitialMessages();

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
            (OSNotificationReceivedEvent event) {
          // Will be called whenever a notification is received in foreground
          // Display Notification, pass null param for not displaying the notification
              print("Received Notif title: ${event.notification.title}");
              print("Received Notif body: ${event.notification.title}");
              print("Received Notif body: ${event.notification.additionalData}");
              event.complete(event.notification);


          //event.complete(event.notification);
        });

    OneSignal.shared.setNotificationOpenedHandler(
            (OSNotificationOpenedResult result) async {
          if (kDebugMode) {
            print('[notification_service - _handleNotificationOpened()');
          }
          if (kDebugMode) {
            print(
                "Opened notification: ${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}");

            print(result.notification.additionalData!.entries.last);
            print(result.notification.additionalData!['id']);
            Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MessageDetails(
            messageModel!.data![messageModel!.data!.indexWhere((element) => element.id==result.notification.additionalData!['id'].toString())].endPoint,
            messageModel!.data![messageModel!.data!.indexWhere((element) => element.id==result.notification.additionalData!['id'].toString())].email,
            messageModel!.data![messageModel!.data!.indexWhere((element) => element.id==result.notification.additionalData!['id'].toString())])));
          }
        });

    /*Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MessageDetails(
            messageModel!.data![index].endPoint,
            messageModel!.data![index].email,
            messageModel!.data![index])));
*/
  }

  @override
  Widget build(BuildContext context) {
    _scrollController = ScrollController(initialScrollOffset: 50.0);
    size = MediaQuery.of(context).size;
    prefProvider = Provider.of<SharedPrefProvider>(context, listen: true);

    return UpgradeAlert(
      upgrader: Upgrader(
        messages: MyUpgraderMessages(),
        shouldPopScope: () => false,
        durationUntilAlertAgain: const Duration(hours: 144),
        canDismissDialog: false,
        showIgnore: false,
        showLater: false,
        dialogStyle: Platform.isIOS
            ? UpgradeDialogStyle.cupertino
            : UpgradeDialogStyle.material,
      ),
      child: SafeArea(
        child: Scaffold(
          key: drawerScaffoldKey,
          appBar: PreferredSize(
            preferredSize: Size(size.width, 45.h),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        if (drawerScaffoldKey.currentState!.isDrawerOpen) {
                          drawerScaffoldKey.currentState!.openEndDrawer();
                        } else {
                          drawerScaffoldKey.currentState!.openDrawer();
                        }
                      },
                      icon: Image.asset("assets/icons/drawer_icon.png",
                          width: 15.w, height: 15.h, fit: BoxFit.contain)),
                  Container(
                      width: size.width - 88.w,
                      alignment: Alignment.center,
                      child: Text(
                        "Messages",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14.sp),
                      )),
                ],
              ),
            ),
          ),
          drawer: sideNavDrawer(),
          body: DoubleBackToCloseApp(
            snackBar: SnackBar(
              content: Text('Tap back again to leave'),
            ),
            child: _isDataLoaded
                ? Container(
                    width: size.width,
                    height: size.height,
                    color: Colors.white,
                    child: NotificationListener(
                      onNotification: (t) {
                        if (t is ScrollEndNotification) {
                          print(
                              "At Edge ${_scrollController.position.pixels} ${_scrollController.position.maxScrollExtent}");
                          if (_scrollController.position.atEdge) {
                            if (t.metrics.pixels ==
                                _scrollController.position.maxScrollExtent) {
                              print("At Edge");
                              if (messageModel!.totalPages! > currentPage) {
                                setState(() {
                                  currentPage++;
                                  print("AT End $currentPage");
                                  _isNextDataLoading = true;
                                });
                                getMessages();
                              }
                            }
                          }
                        }
                        return true;
                      },
                      child: RefreshIndicator(
                        strokeWidth: 3,
                        triggerMode: RefreshIndicatorTriggerMode.onEdge,
                        onRefresh: () async {
                          setState(() {
                            currentPage = 1;
                            _isDataLoaded = false;
                          });
                          getInitialMessages();
                        },
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 12.h,
                              ),
                              // Container(
                              //   width: size.width,
                              //   height: 40.h,
                              //   margin: EdgeInsets.symmetric(horizontal: 14.w),
                              //   padding: EdgeInsets.symmetric(horizontal: 12.w),
                              //   decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(20.r),
                              //       color: Color(0xfff2f2f2)),
                              //   child: Row(
                              //     children: [
                              //       Icon(
                              //         Icons.search_outlined,
                              //         size: 20.sp,
                              //         color: Color(0xff82858B),
                              //       ),
                              //       SizedBox(
                              //         width: 8.w,
                              //       ),
                              //       SizedBox(
                              //         width: size.width - 90.w,
                              //         child: TextField(
                              //           decoration: InputDecoration(
                              //             contentPadding: EdgeInsets.zero,
                              //             isDense: true,
                              //             border: InputBorder.none,
                              //             hintText: 'Search Messages',
                              //             hintStyle: TextStyle(
                              //                 color: Color(0xff82858B),
                              //                 fontSize: 13.sp,
                              //                 fontWeight: FontWeight.w400,
                              //                 letterSpacing: 0.6),
                              //             prefixStyle: TextStyle(
                              //                 color: Color(0xff000000),
                              //                 fontSize: 13.sp,
                              //                 fontWeight: FontWeight.w400,
                              //                 letterSpacing: 0.6),
                              //           ),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              SizedBox(
                                height: 30.h,
                              ),
                              _isDataLoaded
                                  ? Column(
                                      children: [
                                        messageModel!.data!.length==0?SizedBox(
                                          height: size.height-60.h,
                                          width: size.width,
                                          child: Center(child: Text("No messages", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),)),
                                        ):_messagesList(),
                                        _isNextDataLoading
                                            ? Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 5.h),
                                                child: SizedBox(
                                                  height: 25.h,
                                                  width: 25.h,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2.5,
                                                    color: Color(0xff2464B3),
                                                  ),
                                                ),
                                              )
                                            : SizedBox(
                                                height: 25.h,
                                              ),
                                      ],
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
          ),
        ),
      ),
    );
  }

  Widget _messagesList() {
    print("messenger list in screen: ${messageModel!.data!.length.toString()}");
    return ListView.builder(
        //
        // scrollDirection: Axis.vertical,
        //controller: _scrollController,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: messageModel!.data!.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MessageDetailsNew(
                          messageModel!.data![index].endPoint,
                          messageModel!.data![index].email,
                          messageModel!.data![index])));
                },
                child: Container(
                  height: 42.h,
                  margin: EdgeInsets.only(left: 14.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 55.w,
                        height: 35.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            color:
                                messageModel!.data![index].userType == 'Buyer'
                                    ? Color(0xff1657B1)
                                    : Color(0xffE59E2A)),
                        child: Center(
                          child: Text(
                            "${messageModel!.data![index].userType}",
                             style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: size.width - 80.w,
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    width: size.width - 195.w,
                                    child: Text(
                                      '${messageModel!.data![index].email}',
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          overflow: TextOverflow.ellipsis),
                                    )),
                                Text(
                                  '${messageModel!.data![index].date}',
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w400,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: size.width - 80.w,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 0.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    width: size.width - 140.w,
                                    height: 20.h,
                                    child: Text(
                                      messageModel!.data![index].lastMessage!
                                          .replaceAll(
                                              RegExp(
                                                  r'''[^A-Za-z0-9.,:'" ()-]'''),
                                              ''),
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Color(0xff7B7E83),
                                          fontWeight: FontWeight.w500,
                                          overflow: TextOverflow.ellipsis),
                                    )),
                                messageModel!.data![index].new_mgs != 0
                                    ? Container(
                                        width: 20.w,
                                        height: 20.w,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                            color: Color(0xff1BBC54)),
                                        alignment: Alignment.center,
                                        child: Text(
                                          '${messageModel!.data![index].new_mgs}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10.sp),
                                        ),
                                      )
                                    : SizedBox()
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                color: Color(0xffF2F2F2),
              ),
              SizedBox(
                height: 15.h,
              ),
            ],
          );
        });
  }

  Widget sideNavDrawer() {
    return Drawer(
      child: Container(
        width: size.height - 100,
        height: double.infinity,
        padding: EdgeInsets.fromLTRB(16.w, 25.h, 10.w, 15.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 25.h,
            ),
            Row(
              children: [
                Image.asset(
                  'assets/images/avatar.png',
                  width: 35.w,
                  height: 35.w,
                ),
                SizedBox(
                  width: 10.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${prefProvider.userName}",
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${prefProvider.userEmail!}",
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff535763)),
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: size.height - 360.h,
            ),
            //Divider(thickness: 1,),
            /*InkWell(
              onTap: () async {
                final InAppReview inAppReview = InAppReview.instance;
                inAppReview.openStoreListing();
              },
              child: Center(
                child: Container(
                  width: 120.w,
                  height: 35.h,
                  //margin: EdgeInsets.symmetric(horizontal: 30.w),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(6.r),
                    *//*border: Border(
                    bottom:
                    BorderSide(width: 1.4, color: Color(0xffE2E2E2)),*//*
                  ),

                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star_border_purple500_rounded,
                        size: 22.sp,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        "Rate Us",
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50.h,
            ),*/
            InkWell(
              onTap: () async {
                final result = await Api().logOut(prefProvider.accessToken);
                if ((result.status!) == 'success') {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  await preferences.remove('accessToken');

                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (Route<dynamic> route) => false);
                }
                else{
                  ShowMToast toast = ShowMToast();
                  toast.successToast(context,
                      message: result.message!,
                      textColor: Colors.white,
                      alignment: Alignment.bottomCenter,
                      backgroundColor: Color(0xbb2460ad),
                      icon: Icons.check_circle_outline_rounded,
                      iconColor: Colors.white);

                }
              },
              child: Container(
                width: double.infinity,
                /* decoration: BoxDecoration(border: Border(
                  bottom:
                  BorderSide(width: 1.4, color: Color(0xffE2E2E2)),
                ),),*/
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout_rounded,
                      size: 20.sp,
                      color: Color(0xff535763),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      "Logout",
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff535763)),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
