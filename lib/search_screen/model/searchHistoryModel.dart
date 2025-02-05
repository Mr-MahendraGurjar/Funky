class SearchhistoryModel {
  bool? error;
  String? statusCode;
  String? message;
  List<Data>? data;

  SearchhistoryModel({this.error, this.statusCode, this.message, this.data});

  SearchhistoryModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? userId;
  String? searchUserId;
  String? searchUserName;
  String? createdDate;
  String? updatedDate;

  Data({this.id, this.userId, this.searchUserId, this.searchUserName, this.createdDate, this.updatedDate});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    searchUserId = json['search_user_id'];
    searchUserName = json['search_name'];
    createdDate = json['createdDate'];
    updatedDate = json['updatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['search_user_id'] = this.searchUserId;
    data['search_name'] = this.searchUserName;
    data['createdDate'] = this.createdDate;
    data['updatedDate'] = this.updatedDate;
    return data;
  }
}
