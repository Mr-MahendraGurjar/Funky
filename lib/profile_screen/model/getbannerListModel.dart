class BannerGetList {
  bool? error;
  String? statusCode;
  String? message;
  List<Data>? data;

  BannerGetList({this.error, this.statusCode, this.message, this.data});

  BannerGetList.fromJson(Map<String, dynamic> json) {
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
  String? userId;
  String? logo;
  String? price;
  String? currency;
  String? placeLocation;
  String? brandStartDate;
  String? brandEndDate;
  User? user;

  Data(
      {this.id,
      this.userId,
      this.logo,
      this.price,
      this.currency,
      this.placeLocation,
      this.brandStartDate,
      this.brandEndDate,
      this.user});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    logo = json['logo'];
    price = json['price'];
    currency = json['currency'];
    placeLocation = json['place_location'];
    brandStartDate = json['brand_startDate'];
    brandEndDate = json['brand_endDate'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['logo'] = this.logo;
    data['price'] = this.price;
    data['currency'] = this.currency;
    data['place_location'] = this.placeLocation;
    data['brand_startDate'] = this.brandStartDate;
    data['brand_endDate'] = this.brandEndDate;
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
  String? socialType;
  String? userFollowUnfollow;
  String? userBlockUnblock;
  String? followerNumber;
  String? followingNumber;
  String? facebookLinks;
  String? instagramLinks;
  String? twitterLinks;
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
      this.facebookLinks,
      this.instagramLinks,
      this.twitterLinks,
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
    facebookLinks = json['facebook_links'];
    instagramLinks = json['instagram_links'];
    twitterLinks = json['twitter_links'];
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
    data['social_type'] = this.socialType;
    data['user_followUnfollow'] = this.userFollowUnfollow;
    data['user_blockUnblock'] = this.userBlockUnblock;
    data['follower_number'] = this.followerNumber;
    data['following_number'] = this.followingNumber;
    data['facebook_links'] = this.facebookLinks;
    data['instagram_links'] = this.instagramLinks;
    data['twitter_links'] = this.twitterLinks;
    data['createdDate'] = this.createdDate;
    return data;
  }
}
