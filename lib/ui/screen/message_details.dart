import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../Common Classes/common_functions.dart';
import '../../Core/model/chatbox_messages.dart';
import '../../Core/model/message_data_list.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../Core/services/apis.dart';
import '../../Core/viewModel/shared_pref.dart';

class MessageDetails extends StatefulWidget {
  String? endPoint;
  String? userName;
  MessageDataList messageDataList;
  MessageDetails(this.endPoint, this.userName, this.messageDataList);
  @override
  State<MessageDetails> createState() => _MessageDetailsState();
}

class _MessageDetailsState extends State<MessageDetails> {
  late Size size;
  late Timer _timer;
  String _accessToken = '';
  ChatboxMessage? chatboxMessage;
  bool _isDataLoaded = false;
  bool _isButtonEnabled = true;
  String messages = '';
  Key _key = GlobalKey();

  late StreamSubscription<bool> keyboardSubscription;
  bool isKeyboardVisible = false;

  double bottom = 0.0;


  TextEditingController _textController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  _scrollToBottom() {
    _isDataLoaded
        ? _scrollController.jumpTo(_scrollController.position.maxScrollExtent)
        : null;
  }

  _checkSession() {
    if (checkSessionExpiry == true) {
      CommonFunctions().sessionExpiry(context);
    }
  }

  getMessageDetails() async {
    final pref = Provider.of<SharedPrefProvider>(context, listen: false);
    var result =
        await Api().getMessageDetails(pref.accessToken, widget.endPoint!);
    if (result!.details!.last.status != 'seen' &&
        result!.details!.last.msgType == 'recieved') {
      final apiResult = await Api()
          .readStatusUpdate(pref.accessToken, result!.details!.last.id!);
      result =
          await Api().getMessageDetails(pref.accessToken, widget.endPoint!);
      print(apiResult);
    }

    _checkSession();

    if (result!.status == 'SUCCESS') {
      setState(() {
        chatboxMessage = result;
        _isDataLoaded = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _timer =
        Timer.periodic(Duration(seconds: 30), (Timer t) => getMessageDetails());

    var keyboardVisibilityController = KeyboardVisibilityController();
    // Query
    print('Keyboard visibility direct query: ${keyboardVisibilityController.isVisible}');

    // Subscribe
    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      print('Keyboard visibility update. Is visible: $visible');
      setState(() {
        isKeyboardVisible = visible;
        //_textController.text= _textController.text;
      });
    });
    getMessageDetails();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    keyboardSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    bottom = EdgeInsets.fromViewPadding(
        View.of(context).viewInsets,
        View.of(context).devicePixelRatio).bottom;
    print(bottom);
    print(isKeyboardVisible);

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    final prefProvider =
        Provider.of<SharedPrefProvider>(context, listen: false);

    return KeyboardDismissOnTap(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xffF5F5F5),
        appBar: AppBar(
          iconTheme: IconThemeData(),
          title: Text(
            "${widget.userName}",
            style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Color(0xff2C2B2B)),
          ),
          centerTitle: true,
          backgroundColor: Color(0xffFAFAFA),
          elevation: 0,
        ),
        body: Container(
          height: size.height,
          width: size.width,
          child: Stack(
            children: [
              Positioned(
                child: _isDataLoaded
                  ? Container(
                  height: isKeyboardVisible?size.height-(AppBar().preferredSize.height+bottom+90.h):size.height-(AppBar().preferredSize.height+90.h),
                padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 8.h ),
                child: ListView.builder(
                    itemCount: chatboxMessage!.details!.length,
                    shrinkWrap: true,
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      return Container(
                        //height: 300,
                        width: size.width,
                        margin: EdgeInsets.only(bottom: 12.h),
                        child: chatboxMessage!
                            .details![index].msgType ==
                            'sent'
                            ? Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              //height: 120.h,
                              width:
                              size.width - (size.width / 1.3),
                            ),
                            Container(
                              width: size.width / 1.5,
                              padding: EdgeInsets.only(
                                  left: 10.w,
                                  right: 6.w,
                                  bottom: 5.w),
                              decoration: BoxDecoration(
                                  color: Color(0xffDCF8C7),
                                  borderRadius:
                                  BorderRadius.circular(5.r)),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.end,
                                children: [
                                  Container(
                                      child: Html(
                                        shrinkWrap: true,
                                        data:
                                        '${chatboxMessage!.details![index].messages}',
                                      )
                                    /*Text(
                                                  "${chatboxMessage!.details![index].messages!.replaceAll('<br />', '').replaceAll(RegExp(r'''[^A-Za-z0-9.,:'" ()-] \n'''), '')}",
                                                  style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height: 1.4),
                                                ),*/
                                  ),
                                  Container(
                                      width: size.width / 1.5,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "11 Apr 2023",
                                            style: TextStyle(
                                                fontSize: 10.sp),
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          chatboxMessage!
                                              .details![
                                          index]
                                              .status ==
                                              'seen'
                                              ? Image.asset(
                                              "assets/icons/double_tick.png")
                                              : Image.asset(
                                            "assets/icons/double_tick.png",
                                            color:
                                            Colors.grey,
                                          )
                                        ],
                                      ))
                                ],
                              ),
                            ),
                          ],
                        )
                            : Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              //height: 120.h,
                              width: size.width / 1.5,
                              padding: EdgeInsets.only(
                                  left: 10.w,
                                  right: 6.w,
                                  top: 0.w,
                                  bottom: 5.w),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.circular(5.r)),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    // child: Text(
                                    //   "${chatboxMessage!.details![index].messages}",
                                    //   style: TextStyle(
                                    //       fontSize: 14.sp,
                                    //       fontWeight:
                                    //           FontWeight.w400,
                                    //       height: 1.4),
                                    // ),
                                    child: Html(
                                      data:
                                      '${chatboxMessage!.details![index].messages}',
                                    ),
                                  ),
                                  Container(
                                      width: size.width / 1.5,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "11 Apr 2023",
                                            style: TextStyle(
                                                fontSize: 10.sp),
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          chatboxMessage!
                                              .details![
                                          index]
                                              .status ==
                                              'seen'
                                              ? Image.asset(
                                              "assets/icons/double_tick.png")
                                              : Image.asset(
                                            "assets/icons/double_tick.png",
                                            color:
                                            Colors.grey,
                                          )
                                        ],
                                      ))
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              )
                  : SizedBox(),),
              Positioned(
                bottom: isKeyboardVisible?bottom:0.0,
                child: _isDataLoaded
                  ? chatboxMessage!.listingInfo!.needUpgrade == 0
                  ? Padding(
                padding: EdgeInsets.only(left: 10.w, right: 10.w),
                child: Container(
                  // width: size.width-30.w,
                  height: 42.h,
                  margin: EdgeInsets.only(top: 10.w, bottom: 15.h),
                  // padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.r),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 8,
                            offset: Offset(0, 4),
                            color: Color(0x40D0D0D0)),
                      ]),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20.w,
                      ),
                      SizedBox(
                        width: size.width - 85.w,
                        child: TextField(
                          key: _key,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          enabled: _isDataLoaded
                              ? chatboxMessage!
                              .listingInfo!.needUpgrade ==
                              1
                              ? false
                              : true
                              : true,
                          controller: _textController,
                          maxLines: null,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                            border: InputBorder.none,
                            hintText: 'Write Message',
                            hintStyle: TextStyle(
                                color: Color(0xff2965B0),
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.6),
                            prefixStyle: TextStyle(
                                color: Color(0xff000000),
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.6),
                          ),
                          onChanged: (data) {
                            setState(() {
                              messages = data!;
                            });
                          },
                        ),
                      ),
                      /*_isDataLoaded?chatboxMessage!.listingInfo!.needUpgrade==0?*/ IconButton(
                        icon: Icon(Icons.send),
                        color: Color(0xff2965B0),
                        iconSize: 20.sp,
                        onPressed: () async {
                          if (_isButtonEnabled) {
                            setState(() {
                              _isButtonEnabled = false;
                            });
                            if (_textController.text != '') {
                              final result = await Api().sendMessage(
                                  prefProvider.accessToken,
                                  _textController.text,
                                  widget.messageDataList.advertType!,
                                  widget.messageDataList.advertId!,
                                  widget.messageDataList.id!);
                              setState(() {
                                messages = '';
                                _textController.clear();
                                _isButtonEnabled = true;
                                getMessageDetails();
                              });
                            } else {
                              EasyLoading.showToast(
                                  "No message to send");
                            }
                          }
                        },
                      ) /*:Icon(Icons.lock_outline_rounded, color: Colors.grey, size: 20.sp,):SizedBox()
                    */
                    ],
                  ),
                ),
              )
                  : Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 15,
                    offset:
                    Offset(0, 2), // changes position of shadow
                  ),
                ]),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.r),
                      topRight: Radius.circular(12.r)),
                  child: Container(
                    height: 70.h,
                    width: size.width,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: size.width,
                          height: 5.h,
                          color: Colors.red,
                        ),
                        SizedBox(
                          height: 13.h,
                        ),
                        Row(
                          children: [
                            // Container(
                            //   width: 5.w,
                            //   height: double.infinity,
                            //   color: Colors.red,
                            // ),
                            SizedBox(
                              width: 20.w,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: size.width - 185,
                                  child: Text(
                                    "Some features are restricted ",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        height: 1.4,
                                        color: Color(0xff737080)),
                                  ),
                                ),
                                SizedBox(
                                  width: 20.w,
                                ),
                                InkWell(
                                  onTap: () {
                                    final Uri _url = Uri.parse(
                                        chatboxMessage!
                                            .listingInfo!.callBack!);
                                    CommonFunctions()
                                        .launchUrlFunc(_url);
                                  },
                                  child: Container(
                                    width: 100.w,
                                    height: 30.h,
                                    decoration: BoxDecoration(
                                        color: Color(0XFFE94A60),
                                        borderRadius:
                                        BorderRadius.circular(
                                            60.r)),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Learn More',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight:
                                          FontWeight.bold),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
                  : SizedBox(),)
            ],
            /*child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 8.h,),
                _isDataLoaded
                    ? Padding(
                      padding: EdgeInsets.only(left: 10.w, right: 10.w, ),
                      child: ListView.builder(
                          itemCount: chatboxMessage!.details!.length,
                          shrinkWrap: true,
                          controller: _scrollController,
                          itemBuilder: (context, index) {
                            return Container(
                              //height: 300,
                              width: size.width,
                              margin: EdgeInsets.only(bottom: 12.h),
                              child: chatboxMessage!
                                          .details![index].msgType ==
                                      'sent'
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          //height: 120.h,
                                          width:
                                              size.width - (size.width / 1.3),
                                        ),
                                        Container(
                                          width: size.width / 1.5,
                                          padding: EdgeInsets.only(
                                              left: 10.w,
                                              right: 6.w,
                                              bottom: 5.w),
                                          decoration: BoxDecoration(
                                              color: Color(0xffDCF8C7),
                                              borderRadius:
                                                  BorderRadius.circular(5.r)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                  child: Html(
                                                shrinkWrap: true,
                                                data:
                                                    '${chatboxMessage!.details![index].messages}',
                                              )
                                                  *//*Text(
                                                  "${chatboxMessage!.details![index].messages!.replaceAll('<br />', '').replaceAll(RegExp(r'''[^A-Za-z0-9.,:'" ()-] \n'''), '')}",
                                                  style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height: 1.4),
                                                ),*//*
                                                  ),
                                              Container(
                                                  width: size.width / 1.5,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        "11 Apr 2023",
                                                        style: TextStyle(
                                                            fontSize: 10.sp),
                                                      ),
                                                      SizedBox(
                                                        width: 5.w,
                                                      ),
                                                      chatboxMessage!
                                                                  .details![
                                                                      index]
                                                                  .status ==
                                                              'seen'
                                                          ? Image.asset(
                                                              "assets/icons/double_tick.png")
                                                          : Image.asset(
                                                              "assets/icons/double_tick.png",
                                                              color:
                                                                  Colors.grey,
                                                            )
                                                    ],
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          //height: 120.h,
                                          width: size.width / 1.5,
                                          padding: EdgeInsets.only(
                                              left: 10.w,
                                              right: 6.w,
                                              top: 0.w,
                                              bottom: 5.w),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(5.r)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                // child: Text(
                                                //   "${chatboxMessage!.details![index].messages}",
                                                //   style: TextStyle(
                                                //       fontSize: 14.sp,
                                                //       fontWeight:
                                                //           FontWeight.w400,
                                                //       height: 1.4),
                                                // ),
                                                child: Html(
                                                  data:
                                                      '${chatboxMessage!.details![index].messages}',
                                                ),
                                              ),
                                              Container(
                                                  width: size.width / 1.5,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        "11 Apr 2023",
                                                        style: TextStyle(
                                                            fontSize: 10.sp),
                                                      ),
                                                      SizedBox(
                                                        width: 5.w,
                                                      ),
                                                      chatboxMessage!
                                                                  .details![
                                                                      index]
                                                                  .status ==
                                                              'seen'
                                                          ? Image.asset(
                                                              "assets/icons/double_tick.png")
                                                          : Image.asset(
                                                              "assets/icons/double_tick.png",
                                                              color:
                                                                  Colors.grey,
                                                            )
                                                    ],
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                            );
                          }),
                    )
                    : SizedBox(),
                _isDataLoaded
                    ? chatboxMessage!.listingInfo!.needUpgrade == 0
                        ? Padding(
                            padding: EdgeInsets.only(left: 10.w, right: 10.w),
                            child: Container(
                              // width: size.width-30.w,
                              height: 42.h,
                              margin: EdgeInsets.only(top: 10.w, bottom: 15.h),
                              // padding: EdgeInsets.symmetric(horizontal: 12.w),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.r),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                        color: Color(0x40D0D0D0)),
                                  ]),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 20.w,
                                  ),
                                  SizedBox(
                                    width: size.width - 85.w,
                                    child: TextField(
                                      enabled: _isDataLoaded
                                          ? chatboxMessage!
                                          .listingInfo!.needUpgrade ==
                                          1
                                          ? false
                                          : true
                                          : true,
                                      controller: _textController,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                        isDense: true,
                                        border: InputBorder.none,
                                        hintText: 'Write Message',
                                        hintStyle: TextStyle(
                                            color: Color(0xff2965B0),
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.6),
                                        prefixStyle: TextStyle(
                                            color: Color(0xff000000),
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w400,
                                            letterSpacing: 0.6),
                                      ),
                                      onChanged: (data) {
                                        setState(() {
                                          messages = data!;
                                        });
                                      },
                                    ),
                                  ),
                                  *//*_isDataLoaded?chatboxMessage!.listingInfo!.needUpgrade==0?*//* IconButton(
                                    icon: Icon(Icons.send),
                                    color: Color(0xff2965B0),
                                    iconSize: 20.sp,
                                    onPressed: () async {
                                      if (_isButtonEnabled) {
                                        setState(() {
                                          _isButtonEnabled = false;
                                        });
                                        if (_textController.text != '') {
                                          final result = await Api().sendMessage(
                                              prefProvider.accessToken,
                                              _textController.text,
                                              widget.messageDataList.advertType!,
                                              widget.messageDataList.advertId!,
                                              widget.messageDataList.id!);
                                          setState(() {
                                            messages = '';
                                            _textController.clear();
                                            _isButtonEnabled = true;
                                            getMessageDetails();
                                          });
                                        } else {
                                          EasyLoading.showToast(
                                              "No message to send");
                                        }
                                      }
                                    },
                                  ) *//*:Icon(Icons.lock_outline_rounded, color: Colors.grey, size: 20.sp,):SizedBox()
                    *//*
                                ],
                              ),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 15,
                                offset:
                                    Offset(0, 2), // changes position of shadow
                              ),
                            ]),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12.r),
                                  topRight: Radius.circular(12.r)),
                              child: Container(
                                height: 70.h,
                                width: size.width,
                                color: Colors.white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: size.width,
                                      height: 5.h,
                                      color: Colors.red,
                                    ),
                                    SizedBox(
                                      height: 13.h,
                                    ),
                                    Row(
                                      children: [
                                        // Container(
                                        //   width: 5.w,
                                        //   height: double.infinity,
                                        //   color: Colors.red,
                                        // ),
                                        SizedBox(
                                          width: 20.w,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              width: size.width - 185,
                                              child: Text(
                                                "Some features are restricted ",
                                                style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.bold,
                                                    height: 1.4,
                                                    color: Color(0xff737080)),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20.w,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                final Uri _url = Uri.parse(
                                                    chatboxMessage!
                                                        .listingInfo!.callBack!);
                                                CommonFunctions()
                                                    .launchUrlFunc(_url);
                                              },
                                              child: Container(
                                                width: 100.w,
                                                height: 30.h,
                                                decoration: BoxDecoration(
                                                    color: Color(0XFFE94A60),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            60.r)),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Learn More',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                    : SizedBox(),
                isKeyboardVisible ? SizedBox(height: bottom) : SizedBox(),

              ],
            ),*/
          ),
        ),
      ),
    );
  }
}
