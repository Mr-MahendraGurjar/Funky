class GetAuthenticationModel {
  Data? data;
  bool? error;
  String? statusCode;
  String? message;

  GetAuthenticationModel({this.data, this.error, this.statusCode, this.message});

  GetAuthenticationModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    error = json['error'];
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['error'] = this.error;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String? id;
  String? textMessage;

  Data({this.id, this.textMessage});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    textMessage = json['text_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text_message'] = this.textMessage;
    return data;
  }
}
