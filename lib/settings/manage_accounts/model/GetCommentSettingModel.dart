class GetCommentSettingModel {
  Data? data;
  bool? error;
  String? statusCode;
  String? message;

  GetCommentSettingModel({this.data, this.error, this.statusCode, this.message});

  GetCommentSettingModel.fromJson(Map<String, dynamic> json) {
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
  String? userId;
  String? blockComment;
  int? blockCommentCount;

  Data({this.userId, this.blockComment, this.blockCommentCount});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    blockComment = json['block_comment'];
    blockCommentCount = json['block_comment_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['block_comment'] = this.blockComment;
    data['block_comment_count'] = this.blockCommentCount;
    return data;
  }
}
