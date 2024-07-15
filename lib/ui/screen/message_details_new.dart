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
import '../widgets/chat_list_view.dart';
import 'global_members.dart';
import 'message_data_modal.dart';

class MessageDetailsNew extends StatefulWidget {
  String? endPoint;
  String? userName;
  MessageDataList messageDataList;
  MessageDetailsNew(this.endPoint, this.userName, this.messageDataList);
  @override
  State<MessageDetailsNew> createState() => _MessageDetailsNewState();
}

class _MessageDetailsNewState extends State<MessageDetailsNew> {
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

  // _scrollToBottom() {
  //   _isDataLoaded
  //       ? _scrollController.jumpTo(_scrollController.position.maxScrollExtent)
  //       : null;
  // }

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
    /*_timer =
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
    });*/
    getMessageDetails();
  }

  /*@override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    keyboardSubscription.cancel();
    super.dispose();
  }*/
  TextEditingController textEditingController = TextEditingController();


  Future<void> scrollAnimation() async {
    return await Future.delayed(
        const Duration(milliseconds: 100),
            () => _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.linear));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4D5482),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4D5482),
        leadingWidth: 50.0,
        titleSpacing: -8.0,
        leading: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: CircleAvatar(
            backgroundColor: Color(0xFF90C953),
            child: Text('X',
                style: TextStyle(
                  color: Colors.black,
                )),
          ),
        ),
        title: const ListTile(
          title: Text('XD Usama',
              style: TextStyle(
                color: Colors.white,
              )),
          subtitle: Text('online',
              style: TextStyle(
                color: Colors.white70,
              )),
        ),
        actions: const [
          Icon(Icons.videocam),
          Padding(
            padding: EdgeInsets.only(right: 20.0, left: 20.0),
            child: Icon(Icons.call),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: ChatListView(scrollController: _scrollController)),
          Container(
            // height: 50,
            margin: const EdgeInsets.all(8.0),
            decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                color: Color(0xFF333D56),
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  margin:
                  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 12.0),
                  child: Transform.rotate(
                      angle: 45,
                      child: const Icon(
                        Icons.attach_file_sharp,
                        color: Colors.white,
                      )),
                ),
                Expanded(
                  child: TextFormField(
                    controller: textEditingController,
                    cursorColor: Colors.white,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 6,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  margin:
                  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 11.0),
                  child: Transform.rotate(
                    angle: -3.14 / 5,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            messageList.add(
                                MessageData(textEditingController.text, true));
                            textEditingController.clear();
                            scrollAnimation();
                          });
                        },
                        onLongPress: () {
                          setState(() {
                            messageList.add(
                                MessageData(textEditingController.text, false));
                            textEditingController.clear();
                            scrollAnimation();
                          });
                        },
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  // Widget build(BuildContext context) {
  //   size = MediaQuery.of(context).size;
  //   bottom = EdgeInsets.fromViewPadding(
  //       View.of(context).viewInsets,
  //       View.of(context).devicePixelRatio).bottom;
  //   print(bottom);
  //   print(isKeyboardVisible);
  //
  //   WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  //   final prefProvider =
  //   Provider.of<SharedPrefProvider>(context, listen: false);
  //
  //   return Scaffold(
  //     backgroundColor: const Color(0xFF4D5482),
  //     appBar: AppBar(
  //       backgroundColor: const Color(0xFF4D5482),
  //       leadingWidth: 50.0,
  //       titleSpacing: -8.0,
  //       leading: const Padding(
  //         padding: EdgeInsets.only(left: 8.0),
  //         child: CircleAvatar(
  //           backgroundColor: Color(0xFF90C953),
  //           child: Text('X',
  //               style: TextStyle(
  //                 color: Colors.black,
  //               )),
  //         ),
  //       ),
  //       title: const ListTile(
  //         title: Text('XD Usama',
  //             style: TextStyle(
  //               color: Colors.white,
  //             )),
  //         subtitle: Text('online',
  //             style: TextStyle(
  //               color: Colors.white70,
  //             )),
  //       ),
  //       actions: const [
  //         Icon(Icons.videocam),
  //         Padding(
  //           padding: EdgeInsets.only(right: 20.0, left: 20.0),
  //           child: Icon(Icons.call),
  //         ),
  //       ],
  //     ),
  //     body: Column(
  //       children: [
  //         Expanded(child: ChatListView(scrollController: _scrollController, chatboxMessage: chatboxMessage!,)),
  //         Container(
  //           // height: 50,
  //           margin: const EdgeInsets.all(8.0),
  //           decoration: const BoxDecoration(
  //               shape: BoxShape.rectangle,
  //               color: Color(0xFF333D56),
  //               borderRadius: BorderRadius.all(Radius.circular(15.0))),
  //           child: Row(
  //             crossAxisAlignment: CrossAxisAlignment.end,
  //             children: [
  //               Container(
  //                 margin:
  //                 const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 12.0),
  //                 child: Transform.rotate(
  //                     angle: 45,
  //                     child: const Icon(
  //                       Icons.attach_file_sharp,
  //                       color: Colors.white,
  //                     )),
  //               ),
  //               Expanded(
  //                 child: TextFormField(
  //                   controller: _textController,
  //                   cursorColor: Colors.white,
  //                   keyboardType: TextInputType.multiline,
  //                   minLines: 1,
  //                   maxLines: 6,
  //                   style: const TextStyle(color: Colors.white),
  //                   decoration: const InputDecoration(
  //                     hintText: 'Type your message...',
  //                     hintStyle: TextStyle(color: Colors.grey),
  //                     border: InputBorder.none,
  //                   ),
  //                 ),
  //               ),
  //               Container(
  //                 margin:
  //                 const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 11.0),
  //                 child: Transform.rotate(
  //                   angle: -3.14 / 5,
  //                   child: Padding(
  //                     padding: const EdgeInsets.only(bottom: 5.0),
  //                     child: GestureDetector(
  //                       onTap: () async {
  //                         if (_isButtonEnabled) {
  //                           setState(() {
  //                             _isButtonEnabled = false;
  //                           });
  //                           if (_textController.text != '') {
  //                             final result = await Api().sendMessage(
  //                                 prefProvider.accessToken,
  //                                 _textController.text,
  //                                 widget.messageDataList.advertType!,
  //                                 widget.messageDataList.advertId!,
  //                                 widget.messageDataList.id!);
  //                             setState(() {
  //                               messages = '';
  //                               _textController.clear();
  //                               _isButtonEnabled = true;
  //                               getMessageDetails();
  //                             });
  //                           } else {
  //                             EasyLoading.showToast(
  //                                 "No message to send");
  //                           }
  //                         }
  //                       },
  //
  //                       child: const Icon(
  //                         Icons.send,
  //                         color: Colors.white,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
