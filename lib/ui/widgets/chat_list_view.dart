


import 'package:app/Core/model/chatbox_messages.dart';
import 'package:app/ui/widgets/receiver_row_view.dart';
import 'package:app/ui/widgets/sender_row_view.dart';
import 'package:flutter/material.dart';

import '../screen/global_members.dart';

class ChatListView extends StatelessWidget {
  const ChatListView({Key? key, required this.scrollController}) : super(key: key);

  final ScrollController scrollController;
 // final ChatboxMessage chatboxMessage;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      controller: scrollController,
      itemCount: messageList.length,
      itemBuilder: (context, index) => (messageList[index].isSender)
          ?  SenderRowView(senderMessage: messageList[index].message)
          : ReceiverRowView(receiverMessage: messageList[index].message),
    );
  }
}
