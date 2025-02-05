class TermsServiceModel {
  String? error;
  String? statusCode;
  String? message;
  Data? data;

  TermsServiceModel({this.error, this.statusCode, this.message, this.data});

  TermsServiceModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    statusCode = json['status_code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? iamge;
  String? content;

  Data({this.iamge, this.content});

  Data.fromJson(Map<String, dynamic> json) {
    iamge = json['iamge'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['iamge'] = this.iamge;
    data['content'] = this.content;
    return data;
  }
}
