class GetUserSettingModel {
  bool? error;
  String? statusCode;
  String? message;
  User? user;

  GetUserSettingModel({this.error, this.statusCode, this.message, this.user});

  GetUserSettingModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    statusCode = json['status_code'];
    message = json['message'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  String? userId;
  String? changeAccount;
  String? suggestedAccount;
  String? adsPersonalization;
  String? downloadData;
  String? likedVideo;
  String? socialMediaLinks;
  String? commentVideoPhoto;
  String? viewPhotoVideo;
  String? viewStory;
  String? groupChat;
  String? viewLive;
  String? commentOnLive;
  String? joinLive;

  User(
      {this.userId,
      this.changeAccount,
      this.suggestedAccount,
      this.adsPersonalization,
      this.downloadData,
      this.likedVideo,
      this.socialMediaLinks,
      this.commentVideoPhoto,
      this.viewPhotoVideo,
      this.viewStory,
      this.groupChat,
      this.viewLive,
      this.commentOnLive,
      this.joinLive});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    changeAccount = json['changeAccount'];
    suggestedAccount = json['suggestedAccount'];
    adsPersonalization = json['ads_personalization'];
    downloadData = json['download_data'];
    likedVideo = json['liked_video'];
    socialMediaLinks = json['social_media_links'];
    commentVideoPhoto = json['comment_video_photo'];
    viewPhotoVideo = json['view_photo_video'];
    viewStory = json['view_story'];
    groupChat = json['group_chat'];
    viewLive = json['view_live'];
    commentOnLive = json['comment_on_live'];
    joinLive = json['join_live'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['changeAccount'] = this.changeAccount;
    data['suggestedAccount'] = this.suggestedAccount;
    data['ads_personalization'] = this.adsPersonalization;
    data['download_data'] = this.downloadData;
    data['liked_video'] = this.likedVideo;
    data['social_media_links'] = this.socialMediaLinks;
    data['comment_video_photo'] = this.commentVideoPhoto;
    data['view_photo_video'] = this.viewPhotoVideo;
    data['view_story'] = this.viewStory;
    data['group_chat'] = this.groupChat;
    data['view_live'] = this.viewLive;
    data['comment_on_live'] = this.commentOnLive;
    data['join_live'] = this.joinLive;
    return data;
  }
}
