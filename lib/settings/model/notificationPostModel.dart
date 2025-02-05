class PostNotificationSettingModel {
  bool? error;
  String? statusCode;
  String? message;

  PostNotificationSettingModel({this.error, this.statusCode, this.message});

  PostNotificationSettingModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}
