class GetBlockListModel {
  bool? error;
  String? statusCode;
  String? message;
  List<Data>? data;

  GetBlockListModel({this.error, this.statusCode, this.message, this.data});

  GetBlockListModel.fromJson(Map<String, dynamic> json) {
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
  String? fullName;
  String? userName;
  String? email;
  String? phone;
  String? parentEmail;
  String? password;
  String? gender;
  String? location;
  String? referralCode;
  String? image;
  String? otp;
  String? countryCode;
  String? about;
  String? type;
  String? token;
  String? profileUrl;
  String? socialId;
  String? socialType;
  String? userBlockUnblock;
  String? followerNumber;
  String? followingNumber;
  String? userFollowUnfollow1;
  String? userfollowType;
  String? isActive;
  String? createdDate;
  String? updatedDate;

  Data(
      {this.id,
      this.fullName,
      this.userName,
      this.email,
      this.phone,
      this.parentEmail,
      this.password,
      this.gender,
      this.location,
      this.referralCode,
      this.image,
      this.otp,
      this.countryCode,
      this.about,
      this.type,
      this.token,
      this.profileUrl,
      this.socialId,
      this.socialType,
      this.userBlockUnblock,
      this.followerNumber,
      this.followingNumber,
      this.userFollowUnfollow1,
      this.userfollowType,
      this.isActive,
      this.createdDate,
      this.updatedDate});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    userName = json['userName'];
    email = json['email'];
    phone = json['phone'];
    parentEmail = json['parent_email'];
    password = json['password'];
    gender = json['gender'];
    location = json['location'];
    referralCode = json['referral_code'];
    image = json['image'];
    otp = json['otp'];
    countryCode = json['countryCode'];
    about = json['about'];
    type = json['type'];
    token = json['token'];
    profileUrl = json['profileUrl'];
    socialId = json['socialId'];
    socialType = json['social_type'];
    userBlockUnblock = json['user_blockUnblock'];
    followerNumber = json['follower_number'];
    followingNumber = json['following_number'];
    userFollowUnfollow1 = json['user_followUnfollow1'];
    userfollowType = json['userfollow_type'];
    isActive = json['isActive'];
    createdDate = json['createdDate'];
    updatedDate = json['updatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullName'] = this.fullName;
    data['userName'] = this.userName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['parent_email'] = this.parentEmail;
    data['password'] = this.password;
    data['gender'] = this.gender;
    data['location'] = this.location;
    data['referral_code'] = this.referralCode;
    data['image'] = this.image;
    data['otp'] = this.otp;
    data['countryCode'] = this.countryCode;
    data['about'] = this.about;
    data['type'] = this.type;
    data['token'] = this.token;
    data['profileUrl'] = this.profileUrl;
    data['socialId'] = this.socialId;
    data['social_type'] = this.socialType;
    data['user_blockUnblock'] = this.userBlockUnblock;
    data['follower_number'] = this.followerNumber;
    data['following_number'] = this.followingNumber;
    data['user_followUnfollow1'] = this.userFollowUnfollow1;
    data['userfollow_type'] = this.userfollowType;
    data['isActive'] = this.isActive;
    data['createdDate'] = this.createdDate;
    data['updatedDate'] = this.updatedDate;
    return data;
  }
}
