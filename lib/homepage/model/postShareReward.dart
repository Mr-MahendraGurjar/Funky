class PostShareRewardModel {
  String? statusCode;
  bool? error;
  String? message;

  PostShareRewardModel({this.statusCode, this.error, this.message});

  PostShareRewardModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    error = json['error'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status_code'] = this.statusCode;
    data['error'] = this.error;
    data['message'] = this.message;
    return data;
  }
}
