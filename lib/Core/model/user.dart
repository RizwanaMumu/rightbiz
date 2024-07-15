

import 'package:app/Core/model/user_login_error.dart';

class User {
  var loginStatus;
  List<Errors>? errors;
  String? userId;
  String? userEmail;
  String? userName;
  String? userActive;
  String? accessToken;
  String? status;
  String? message;

  User(
      {this.loginStatus,
        this.userId,
        this.userEmail,
        this.userName,
        this.userActive,
        this.accessToken,
        this.status,
        this.message
      });

  User.fromJson(Map<String, dynamic> json) {
    loginStatus = json['login_status'];
    userId = json['user_id'];
    userEmail = json['user_email'];
    userName = json['user_name'];
    userActive = json['user_active'];
    accessToken = json['access_token'];
    if (json['errors'] != null) {
      errors = <Errors>[];
      json['errors'].forEach((v) {
        errors!.add(new Errors.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }
}