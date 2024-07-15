class SocialLogin {
  bool? loginStatus;
  String? userId;
  String? userEmail;
  String? userName;
  String? accessToken;

  SocialLogin(
      {this.loginStatus,
        this.userId,
        this.userEmail,
        this.userName,
        this.accessToken});

  SocialLogin.fromJson(Map<String, dynamic> json) {
    loginStatus = json['login_status'];
    userId = json['user_id'];
    userEmail = json['user_email'];
    userName = json['user_name'];
    accessToken = json['access_token'];
  }

}

