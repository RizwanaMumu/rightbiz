class SendMessageModel {
  String? status;
  String? message;

  SendMessageModel({this.status, this.message});

  SendMessageModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

}
