class GetPostLikeCount {
  bool? error;
  String? statusCode;
  String? message;
  List<Data_like_post>? data;

  GetPostLikeCount({this.error, this.statusCode, this.message, this.data});

  GetPostLikeCount.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data_like_post>[];
      json['data'].forEach((v) {
        data!.add(new Data_like_post.fromJson(v));
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

class Data_like_post {
  String? id;
  String? status;
  User? user;

  Data_like_post({this.id, this.status, this.user});

  Data_like_post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
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
  String? likeCount;
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
  String? userFollowUnfollow;
  String? userBlockUnblock;
  String? followerNumber;
  String? followingNumber;
  String? socialType;
  String? followerFollowingShowStatus;
  String? socialLinkShowStatus;
  String? facebookLinks;
  String? instagramLinks;
  String? twitterLinks;
  String? createdDate;

  User(
      {this.id,
      this.fullName,
      this.userName,
      this.likeCount,
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
      this.userFollowUnfollow,
      this.userBlockUnblock,
      this.followerNumber,
      this.followingNumber,
      this.socialType,
      this.followerFollowingShowStatus,
      this.socialLinkShowStatus,
      this.facebookLinks,
      this.instagramLinks,
      this.twitterLinks,
      this.createdDate});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    userName = json['userName'];
    likeCount = json['likeCount'];
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
    userFollowUnfollow = json['user_followUnfollow'];
    userBlockUnblock = json['user_blockUnblock'];
    followerNumber = json['follower_number'];
    followingNumber = json['following_number'];
    socialType = json['social_type'];
    followerFollowingShowStatus = json['follower_following_show_status'];
    socialLinkShowStatus = json['social_link_show_status'];
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
    data['likeCount'] = this.likeCount;
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
    data['user_followUnfollow'] = this.userFollowUnfollow;
    data['user_blockUnblock'] = this.userBlockUnblock;
    data['follower_number'] = this.followerNumber;
    data['following_number'] = this.followingNumber;
    data['social_type'] = this.socialType;
    data['follower_following_show_status'] = this.followerFollowingShowStatus;
    data['social_link_show_status'] = this.socialLinkShowStatus;
    data['facebook_links'] = this.facebookLinks;
    data['instagram_links'] = this.instagramLinks;
    data['twitter_links'] = this.twitterLinks;
    data['createdDate'] = this.createdDate;
    return data;
  }
}
