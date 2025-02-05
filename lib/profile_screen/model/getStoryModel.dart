class GetStoryModel {
  List<Data_story>? data;
  bool? error;
  String? statusCode;
  String? message;

  GetStoryModel({this.data, this.error, this.statusCode, this.message});

  GetStoryModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data_story>[];
      json['data'].forEach((v) {
        data!.add(Data_story.fromJson(v));
      });
    }
    error = json['error'];
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['error'] = error;
    data['status_code'] = statusCode;
    data['message'] = message;
    return data;
  }
}

class Data_story {
  String? stID;

  String? fullName;
  String? userName;
  String? image;
  String? title;
  String? dateTime;
  User? user;
  List<Storys>? storys;

  Data_story(
      {this.stID,
      this.fullName,
      this.userName,
      this.image,
      this.title,
      this.dateTime,
      this.user,
      this.storys});

  Data_story.fromJson(Map<String, dynamic> json) {
    stID = json['stID'];
    fullName = json['fullName'];
    userName = json['userName'];
    image = json['image'];
    title = json['title'];
    dateTime = json['dateTime'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    if (json['storys'] != null) {
      storys = <Storys>[];
      json['storys'].forEach((v) {
        storys!.add(Storys.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['stID'] = stID;
    data['fullName'] = fullName;
    data['userName'] = userName;
    data['image'] = image;
    data['title'] = title;
    data['dateTime'] = dateTime;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (storys != null) {
      data['storys'] = storys!.map((v) => v.toJson()).toList();
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
  String? socialType;
  String? userFollowUnfollow;
  String? userBlockUnblock;
  String? followerNumber;
  String? followingNumber;
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
      this.socialType,
      this.userFollowUnfollow,
      this.userBlockUnblock,
      this.followerNumber,
      this.followingNumber,
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
    socialType = json['social_type'];
    userFollowUnfollow = json['user_followUnfollow'];
    userBlockUnblock = json['user_blockUnblock'];
    followerNumber = json['follower_number'];
    followingNumber = json['following_number'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fullName'] = fullName;
    data['userName'] = userName;
    data['email'] = email;
    data['phone'] = phone;
    data['parent_email'] = parentEmail;
    data['gender'] = gender;
    data['location'] = location;
    data['referral_code'] = referralCode;
    data['image'] = image;
    data['about'] = about;
    data['type'] = type;
    data['profileUrl'] = profileUrl;
    data['socialId'] = socialId;
    data['social_type'] = socialType;
    data['user_followUnfollow'] = userFollowUnfollow;
    data['user_blockUnblock'] = userBlockUnblock;
    data['follower_number'] = followerNumber;
    data['following_number'] = followingNumber;
    data['createdDate'] = createdDate;
    return data;
  }
}

class Storys {
  String? stID;
  String? userId;
  String? stoID;
  String? storyPhoto;
  String? uploadVideo;
  String? isVideo;
  String? viewCount;
  String? dateTime;
  String? type;

  Storys(
      {this.stID,
      this.userId,
      this.stoID,
      this.storyPhoto,
      this.uploadVideo,
      this.isVideo,
      this.viewCount,
      this.dateTime,
      this.type});

  Storys.fromJson(Map<String, dynamic> json) {
    stID = json['stID'];
    userId = json['userId'];
    stoID = json['stoID'];
    storyPhoto = json['story_photo'];
    uploadVideo = json['uploadVideo'];
    isVideo = json['isVideo'];
    viewCount = json['viewCount'];
    dateTime = json['dateTime'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['stID'] = stID;
    data['userId'] = userId;
    data['stoID'] = stoID;
    data['story_photo'] = storyPhoto;
    data['uploadVideo'] = uploadVideo;
    data['isVideo'] = isVideo;
    data['viewCount'] = viewCount;
    data['dateTime'] = dateTime;
    data['type'] = type;
    return data;
  }
}
