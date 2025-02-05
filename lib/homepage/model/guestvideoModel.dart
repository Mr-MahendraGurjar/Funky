class GuestVideoModel {
  List<Data_guest>? data;
  bool? error;
  String? statusCode;
  String? message;

  GuestVideoModel({this.data, this.error, this.statusCode, this.message});

  GuestVideoModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data_guest>[];
      json['data'].forEach((v) {
        data!.add(new Data_guest.fromJson(v));
      });
    }
    error = json['error'];
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['error'] = this.error;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}

class Data_guest {
  String? iD;
  String? originalAudioName;
  String? musicName;
  String? tagLine;
  String? description;
  String? address;
  String? postImage;
  String? uploadVideo;
  String? isVideo;
  String? likes;
  String? likeStatus;
  String? commentCount;
  String? shareCount;
  String? rewardCount;
  String? viewsCount;
  String? enableDownload;
  String? enableComment;
  String? allowAds;
  String? postCreatedDate;
  User? user;

  Data_guest(
      {this.iD,
      this.originalAudioName,
      this.musicName,
      this.tagLine,
      this.description,
      this.address,
      this.postImage,
      this.uploadVideo,
      this.isVideo,
      this.likes,
      this.likeStatus,
      this.commentCount,
      this.shareCount,
      this.rewardCount,
      this.viewsCount,
      this.enableDownload,
      this.enableComment,
      this.allowAds,
      this.postCreatedDate,
      this.user});

  Data_guest.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    originalAudioName = json['OriginalAudioName'];
    musicName = json['musicName'];
    tagLine = json['tagLine'];
    description = json['description'];
    address = json['address'];
    postImage = json['postImage'];
    uploadVideo = json['uploadVideo'];
    isVideo = json['isVideo'];
    likes = json['likes'];
    likeStatus = json['likeStatus'];
    commentCount = json['commentCount'];
    shareCount = json['shareCount'];
    rewardCount = json['rewardCount'];
    viewsCount = json['viewsCount'];
    enableDownload = json['enableDownload'];
    enableComment = json['enableComment'];
    allowAds = json['allowAds'];
    postCreatedDate = json['post_createdDate'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['OriginalAudioName'] = this.originalAudioName;
    data['musicName'] = this.musicName;
    data['tagLine'] = this.tagLine;
    data['description'] = this.description;
    data['address'] = this.address;
    data['postImage'] = this.postImage;
    data['uploadVideo'] = this.uploadVideo;
    data['isVideo'] = this.isVideo;
    data['likes'] = this.likes;
    data['likeStatus'] = this.likeStatus;
    data['commentCount'] = this.commentCount;
    data['shareCount'] = this.shareCount;
    data['rewardCount'] = this.rewardCount;
    data['viewsCount'] = this.viewsCount;
    data['enableDownload'] = this.enableDownload;
    data['enableComment'] = this.enableComment;
    data['allowAds'] = this.allowAds;
    data['post_createdDate'] = this.postCreatedDate;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  String? id;
  String? fullName;
  String? userName;
  String? email;
  String? phone;
  String? parentEmail;
  String? gender;
  String? location;
  String? referralCode;
  String? image;
  String? about;
  String? type;
  String? profileUrl;
  String? socialId;
  String? followerNumber;
  String? followingNumber;
  String? socialType;
  String? verify;
  String? createdDate;

  User(
      {this.id,
      this.fullName,
      this.userName,
      this.email,
      this.phone,
      this.parentEmail,
      this.gender,
      this.location,
      this.referralCode,
      this.image,
      this.about,
      this.type,
      this.profileUrl,
      this.socialId,
      this.followerNumber,
      this.followingNumber,
      this.socialType,
      this.verify,
      this.createdDate});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    userName = json['userName'];
    email = json['email'];
    phone = json['phone'];
    parentEmail = json['parent_email'];
    gender = json['gender'];
    location = json['location'];
    referralCode = json['referral_code'];
    image = json['image'];
    about = json['about'];
    type = json['type'];
    profileUrl = json['profileUrl'];
    socialId = json['socialId'];
    followerNumber = json['follower_number'];
    followingNumber = json['following_number'];
    socialType = json['social_type'];
    verify = json['verify'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullName'] = this.fullName;
    data['userName'] = this.userName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['parent_email'] = this.parentEmail;
    data['gender'] = this.gender;
    data['location'] = this.location;
    data['referral_code'] = this.referralCode;
    data['image'] = this.image;
    data['about'] = this.about;
    data['type'] = this.type;
    data['profileUrl'] = this.profileUrl;
    data['socialId'] = this.socialId;
    data['follower_number'] = this.followerNumber;
    data['following_number'] = this.followingNumber;
    data['social_type'] = this.socialType;
    data['verify'] = this.verify;
    data['createdDate'] = this.createdDate;
    return data;
  }
}
