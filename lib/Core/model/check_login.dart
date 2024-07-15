class CheckLoginModel {
  bool? loginStatus;
  String? userId;
  String? email;

  CheckLoginModel({this.loginStatus, this.userId, this.email});

  CheckLoginModel.fromJson(Map<String, dynamic> json) {
    loginStatus = json['login_status'];
    userId = json['user_id'];
    email = json['email'];
  }

}