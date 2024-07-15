class Errors {
  String? selector;
  String? message;

  Errors({this.selector, this.message});

  Errors.fromJson(Map<String, dynamic> json) {
    selector = json['selector'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['selector'] = this.selector;
    data['message'] = this.message;
    return data;
  }
}