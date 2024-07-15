class MessageDataList {
  String? id;
  String? lastMessage;
  String? advertId;
  String? date;
  String? userType;
  String? email;
  int? new_mgs;
  String? endPoint;
  String? advertType;

  MessageDataList(
      {this.id,
      this.lastMessage,
        this.advertId,
        this.date,
        this.userType,
        this.email,
        this.new_mgs,
        this.endPoint,
        this.advertType
      });

  MessageDataList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lastMessage = json['last_message'];
    advertId = json['advert_id'];
    date = json['date'];
    userType = json['user_type'];
    email = json['email'];
    new_mgs = json['new_mgs'];
    endPoint = json['end_point'];
    advertType = json['advert_type'];
  }


}