class GetNotificationSettingModel {
  List<NotificationSetting>? notificationSetting;
  bool? error;
  String? statusCode;
  String? message;

  GetNotificationSettingModel({this.notificationSetting, this.error, this.statusCode, this.message});

  GetNotificationSettingModel.fromJson(Map<String, dynamic> json) {
    if (json['notification_setting'] != null) {
      notificationSetting = <NotificationSetting>[];
      json['notification_setting'].forEach((v) {
        notificationSetting!.add(new NotificationSetting.fromJson(v));
      });
    }
    error = json['error'];
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.notificationSetting != null) {
      data['notification_setting'] = this.notificationSetting!.map((v) => v.toJson()).toList();
    }
    data['error'] = this.error;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}

class NotificationSetting {
  String? id;
  String? userId;
  String? pauseAll;
  String? postStoryComment;
  String? followingFollowers;
  String? messageCall;
  String? liveVideo;
  String? fromFunky;
  String? createdDate;
  String? updatedDate;

  NotificationSetting(
      {this.id,
      this.userId,
      this.pauseAll,
      this.postStoryComment,
      this.followingFollowers,
      this.messageCall,
      this.liveVideo,
      this.fromFunky,
      this.createdDate,
      this.updatedDate});

  NotificationSetting.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    pauseAll = json['pause_all'];
    postStoryComment = json['post_story_comment'];
    followingFollowers = json['following_followers'];
    messageCall = json['message_call'];
    liveVideo = json['live_video'];
    fromFunky = json['from_funky'];
    createdDate = json['createdDate'];
    updatedDate = json['updatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['pause_all'] = this.pauseAll;
    data['post_story_comment'] = this.postStoryComment;
    data['following_followers'] = this.followingFollowers;
    data['message_call'] = this.messageCall;
    data['live_video'] = this.liveVideo;
    data['from_funky'] = this.fromFunky;
    data['createdDate'] = this.createdDate;
    data['updatedDate'] = this.updatedDate;
    return data;
  }
}
