import 'message_details_model.dart';

class ChatboxMessage {
  String? status;
  int? total;
  int? currentPage;
  Null? totalPages;
  Null? maxDataShowing;
  ListingInfo? listingInfo;
  List<MessageDetailsModel>? details;

  ChatboxMessage(
      {this.status,
        this.total,
        this.currentPage,
        this.totalPages,
        this.maxDataShowing,
        this.listingInfo,
        this.details});

  ChatboxMessage.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    total = json['total'];
    currentPage = json['current_page'];
    totalPages = json['total_pages'];
    maxDataShowing = json['max_data_showing'];
    listingInfo = json['listing_info'] != null
        ? new ListingInfo.fromJson(json['listing_info'])
        : null;
    if (json['data'] != null) {
      details = <MessageDetailsModel>[];
      json['data'].forEach((v) {
        details!.add(new MessageDetailsModel.fromJson(v));
      });
    }
  }


}

class ListingInfo {
  int? needUpgrade;
  String? headline;
  String? advertLink;
  String? contactMail;
  String? contactTel;
  String? contactAddress;
  int? chatId;
  String? callBack;

  ListingInfo(
      {this.needUpgrade,
        this.headline,
        this.advertLink,
        this.contactMail,
        this.contactTel,
        this.contactAddress,
        this.chatId,
        this.callBack
      });

  ListingInfo.fromJson(Map<String, dynamic> json) {
    needUpgrade = json['need_upgrade'];
    headline = json['headline'];
    advertLink = json['advert_link'];
    contactMail = json['contact_mail'];
    contactTel = json['contact_tel'];
    contactAddress = json['contact_address'];
    chatId = json['chat_id'];
    callBack = json['callback'];
  }
}
