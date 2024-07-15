import 'message_data_list.dart';

class GetMessageModel {
  String? status;
  int? total;
  int? currentPage;
  int? totalPages;
  int? maxDataShowing;
  List<MessageDataList>? data;

  GetMessageModel(
      {this.status,
        this.total,
        this.currentPage,
        this.totalPages,
        this.maxDataShowing,
        this.data});

  GetMessageModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    total = json['total'];
    currentPage = json['current_page'];
    totalPages = json['total_pages'];
    maxDataShowing = json['max_data_showing'];
    if (json['data'] != null) {
      data = <MessageDataList>[];
      json['data'].forEach((v) {
        data!.add(new MessageDataList.fromJson(v));
      });
    }
  }


}
