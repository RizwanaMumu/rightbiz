class MessageDetailsModel {
  String? id;
  String? msgType;
  String? name;
  String? messages;
  String? status;

  MessageDetailsModel({this.id, this.msgType, this.name, this.messages, this.status});

  MessageDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    msgType = json['msg_type'];
    name = json['name'];
    messages = json['messages'];
    status = json['status'];
  }
}