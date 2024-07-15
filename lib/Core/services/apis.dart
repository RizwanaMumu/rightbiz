import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Common Classes/app_constants.dart';
import '../model/chatbox_messages.dart';
import '../model/check_login.dart';
import '../model/get_message_model.dart';
import '../model/logout.dart';
import '../model/read_status_message.dart';
import '../model/send_message_model.dart';
import '../model/user.dart';
import 'dart:developer' as logDev;

bool checkSessionExpiry = false;

class Api {
  var client = http.Client();
  Map<String, String> headers = {"content-type": "application/json"};
  Map<String, String> messageheaders = {"content-type": "application/json"};
  //Map<String, String> cookies = {};

  Future<User> getUserLogin(String email, String password) async {
    final String endpoint = "/api/app/login.php";
    if (kDebugMode) {
      print("endpoint:" + endpoint);
    }

    final Map<String, dynamic> body = {'email': email, 'password': password};

    String jsonBody = json.encode(body);
    print("api scrn email ${email} pass ${password}");

    final uri = Uri.parse(UrlConstants.baseUrl + endpoint);

    if (kDebugMode) {
      print(uri);
    }

    var response = await http.post(
      uri,
      body: jsonBody,
      headers: headers,
    );

    final cookies = response.headers['set-cookie'];
    logDev.log(cookies.toString());
    SharedPreferences.getInstance().then(
      (prefs) {
        prefs.setString('loginCookie', cookies!);
      },
    );
    headers = {
      'cookie': cookies!,
      'accept': 'application/json',
    };

    final dataResponse = await http.post(
      uri,
      body: jsonBody,
      headers: headers,
    );

    User responseList = User();
    if (dataResponse.statusCode == 200) {
      var jsonString = dataResponse.body;
      if (kDebugMode) {
        print("Login JsonString resonse " + jsonString);
      }
      final decoded = jsonDecode(jsonString);
      responseList = User.fromJson(decoded);
      return responseList;
    } else {
      var jsonString = response.body;
      print("Statuscode not 200 " + jsonString);
      return responseList;
    }
  }

  Future<User> getUserSocialLogin(String token) async {
    final String endpoint = "/api/app/login.php";
    if (kDebugMode) {
      print("endpoint:" + endpoint);
    }

    final Map<String, dynamic> params = {
      'access_token': '${token}',
    };

    //final uri = Uri.parse(UrlConstants.baseUrl + endpoint+((params!=null)? this.queryParameters(params):""));

    /* if (kDebugMode) {
      print(uri);
    }*/

    var response = await http.post(Uri.parse(UrlConstants.baseUrl +
        endpoint +
        ((params != null) ? this.queryParameters(params) : "")));

    User responseList = User();
    if (response.statusCode == 200) {
      var jsonString = response.body;
      if (kDebugMode) {
        print("Login JsonString resonse " + jsonString);
      }
      final decoded = jsonDecode(jsonString);
      responseList = User.fromJson(decoded);
      return responseList;
    } else {
      var jsonString = response.body;
      print("Statuscode not 200 " + jsonString);
      return responseList;
    }
  }

  Future<User> getUserSocialAppleLogin(String token) async {
    final String endpoint = "/api/app/apple.php";
    if (kDebugMode) {
      print("endpoint:" + endpoint);
    }

    final Map<String, dynamic> params = {
      'code': '${token}',
    };
    final Uri uri = Uri.parse(UrlConstants.baseUrl +
        endpoint +
        ((params != null) ? this.queryParameters(params) : ""));
    print(uri);

    var response = await http.post(uri);

    User responseList = User();
    if (response.statusCode == 200) {
      var jsonString = response.body;
      if (kDebugMode) {
        print("Apple Login JsonString response " + jsonString);
      }
      final decoded = jsonDecode(jsonString);
      responseList = User.fromJson(decoded);
      return responseList;
    } else {
      var jsonString = response.body;
      print("Statuscode not 200 " + jsonString);
      return responseList;
    }
  }

  _checkSessionExpiry(String string) {
    if (string.contains("Invaild access")) {
      print("token expired.");
      checkSessionExpiry = true;
    } else {
      checkSessionExpiry = false;
    }
  }

  Future<Null> testCookieCheck(String testCookie) async {
    final String endpoint = "/api/app/test-cookie.php";
    if (kDebugMode) {
      print("endpoint:" + endpoint);
    }

    final uri = Uri.parse(UrlConstants.baseUrl + endpoint);

    if (kDebugMode) {
      print(uri);
    }

    headers = {
      'cookie': testCookie!,
      'accept': 'application/json',
    };

    final dataResponse = await http.post(
      uri,
      headers: headers,
    );

    print(dataResponse.body);
  }

  Future<GetMessageModel?> getMessengerList(String token, int id) async {
    const String endpoint = "/api/app/messages.php";
    if (kDebugMode) {
      print("endpoint:" + endpoint);
    }

    final Map<String, dynamic> params = {
      'page': '${id}',
    };
    final uri = Uri.parse(UrlConstants.baseUrl +
        endpoint +
        ((params != null) ? this.queryParameters(params) : ""));

    print(uri);
    print(headers);

    messageheaders = {
      'accept': 'application/json',
      'access-token': token,
    };
    print(messageheaders);
    final dataResponse = await http.get(
      uri,
      headers: messageheaders,
    );
    GetMessageModel responseList = GetMessageModel();
    if (dataResponse.statusCode == 200) {
      var jsonString = dataResponse.body;
      _checkSessionExpiry(jsonString.toString());
      if (kDebugMode) {
        print("Login JsonString response " + jsonString);
      }
      final decoded = jsonDecode(jsonString);
      responseList = GetMessageModel.fromJson(decoded);
      return responseList;
    } else {
      var jsonString = dataResponse.body;
      print("Statuscode not 200 " + jsonString);
      return responseList;
    }
  }

  Future<ChatboxMessage?> getMessageDetails(
      String token, String endPoint) async {
    final uri = Uri.parse(UrlConstants.baseUrl + '/api/app/' + endPoint);
    print(uri);

    messageheaders = {
      'accept': 'application/json',
      'access-token': token,
    };
    print(messageheaders);
    final dataResponse = await http.get(
      uri,
      headers: messageheaders,
    );
    ChatboxMessage responseList = ChatboxMessage();
    if (dataResponse.statusCode == 200) {
      var jsonString = dataResponse.body;
      _checkSessionExpiry(jsonString.toString());
      if (kDebugMode) {
        print("Login JsonString response " + jsonString);
      }
      final decoded = jsonDecode(jsonString);
      responseList = ChatboxMessage.fromJson(decoded);
      return responseList;
    } else {
      var jsonString = dataResponse.body;
      print("Statuscode not 200 " + jsonString);
      return responseList;
    }
  }

  Future<SendMessageModel> sendMessage(String token, String messages,
      String advertType, String advertId, String enqId) async {
    String endPoint = '/api/app/send_message.php';
    final uri = Uri.parse(UrlConstants.baseUrl + endPoint);
    print(uri);

    final Map<String, dynamic> body = {
      'message': messages,
      'advert_type': advertType,
      'advert_id': advertId,
      'enq_id': enqId
    };

    String jsonBody = json.encode(body);

    messageheaders = {
      'accept': 'application/json',
      'access-token': token,
    };
    print(messageheaders);
    final dataResponse = await http.post(
      uri,
      body: jsonBody,
      headers: messageheaders,
    );
    SendMessageModel responseList = SendMessageModel();
    if (dataResponse.statusCode == 200) {
      var jsonString = dataResponse.body;
      if (kDebugMode) {
        print("Login JsonString response " + jsonString);
      }
      final decoded = jsonDecode(jsonString);
      responseList = SendMessageModel.fromJson(decoded);
      return responseList;
    } else {
      var jsonString = dataResponse.body;
      print("Statuscode not 200 " + jsonString);
      return responseList;
    }
  }

  Future<CheckLoginModel> checkLogin(String token) async {
    String endPoint = '/api/app/check-login.php';
    final uri = Uri.parse(UrlConstants.baseUrl + endPoint);
    print(uri);

    final Map<String, dynamic> body = {'access_token': token};

    String jsonBody = json.encode(body);

    final dataResponse = await http.post(
      uri,
      body: jsonBody,
    );

    CheckLoginModel responseList = CheckLoginModel();
    if (dataResponse.statusCode == 200) {
      var jsonString = dataResponse.body;
      if (kDebugMode) {
        print("Login JsonString response " + jsonString);
      }
      final decoded = jsonDecode(jsonString);
      responseList = CheckLoginModel.fromJson(decoded);
      return responseList;
    } else {
      var jsonString = dataResponse.body;
      print("Statuscode not 200 " + jsonString);
      return responseList;
    }
  }

  Future<LogoutModel> logOut(String token) async {
    String endPoint = '/api/app/logout.php';
    final uri = Uri.parse(UrlConstants.baseUrl + endPoint);
    print(uri);

    headers = {
      'accept': 'application/json',
      'access-token': token,
    };

    final dataResponse = await http.get(
      uri,
      headers: headers,
    );

    LogoutModel responseList = LogoutModel();
    if (dataResponse.statusCode == 200) {
      var jsonString = dataResponse.body;
      if (kDebugMode) {
        print("Login JsonString response " + jsonString);
      }
      final decoded = jsonDecode(jsonString);
      responseList = LogoutModel.fromJson(decoded);
      return responseList;
    } else {
      var jsonString = dataResponse.body;
      print("Statuscode not 200 " + jsonString);
      return responseList;
    }
  }

  Future<ReadMessageModel> readStatusUpdate(String token, String id) async {
    String endPoint = '/api/app/update_read_message.php';
    final uri = Uri.parse(UrlConstants.baseUrl + endPoint);
    print(uri);
    final Map<String, dynamic> body = {'id': id};

    String jsonBody = json.encode(body);
    headers = {
      'accept': 'application/json',
      'access-token': token,
    };

    final dataResponse = await http.post(uri, body: jsonBody, headers: headers);

    ReadMessageModel responseList = ReadMessageModel();
    if (dataResponse.statusCode == 200) {
      var jsonString = dataResponse.body;
      if (kDebugMode) {
        print("Read Status JsonString response " + jsonString);
      }
      final decoded = jsonDecode(jsonString);
      responseList = ReadMessageModel.fromJson(decoded);
      return responseList;
    } else {
      var jsonString = dataResponse.body;
      print("Status Code not 200 " + jsonString);
      return responseList;
    }
  }

  /////////-------------------Common------------------/////////
  String queryParameters(Map<String, dynamic> params) {
    if (params != null) {
      final jsonString = Uri(queryParameters: params);
      return '?${jsonString.query}';
    }
    return '';
  }
}
