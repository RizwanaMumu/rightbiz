class ReadMessageModel {
  String? status;
  String? message;

  ReadMessageModel({this.status, this.message});

  ReadMessageModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

}