class LogoutModel {
  String? status;
  String? message;

  LogoutModel({this.status, this.message});

  LogoutModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

}