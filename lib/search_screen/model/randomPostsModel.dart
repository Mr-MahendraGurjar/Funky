class RandomPostsModel {
  List<Data>? data;
  List<Advertisers>? advertisers;
  bool? error;
  String? statusCode;
  String? message;

  RandomPostsModel({this.data, this.advertisers, this.error, this.statusCode, this.message});

  RandomPostsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    if (json['advertisers'] != null) {
      advertisers = <Advertisers>[];
      json['advertisers'].forEach((v) {
        advertisers!.add(new Advertisers.fromJson(v));
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
    if (this.advertisers != null) {
      data['advertisers'] = this.advertisers!.map((v) => v.toJson()).toList();
    }
    data['error'] = this.error;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String? iD;
  String? fullName;
  String? userName;
  String? originalAudioName;
  String? musicName;
  String? image;
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
  String? createdDate;
  User? user;

  Data(
      {this.iD,
      this.fullName,
      this.userName,
      this.originalAudioName,
      this.musicName,
      this.image,
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
      this.createdDate,
      this.user});

  Data.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    fullName = json['fullName'];
    userName = json['userName'];
    originalAudioName = json['OriginalAudioName'];
    musicName = json['musicName'];
    image = json['image'];
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
    createdDate = json['createdDate'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['fullName'] = this.fullName;
    data['userName'] = this.userName;
    data['OriginalAudioName'] = this.originalAudioName;
    data['musicName'] = this.musicName;
    data['image'] = this.image;
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
    data['createdDate'] = this.createdDate;
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

class Advertisers {
  String? id;
  String? advertiserId;
  String? locationStatus;
  String? userId;
  String? bannerImg;
  String? location;
  String? price;
  String? currency;
  String? month;
  String? startDate;
  String? endDate;

  Advertisers(
      {this.id,
      this.advertiserId,
      this.locationStatus,
      this.userId,
      this.bannerImg,
      this.location,
      this.price,
      this.currency,
      this.month,
      this.startDate,
      this.endDate});

  Advertisers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    advertiserId = json['advertiser_id'];
    locationStatus = json['location_status'];
    userId = json['userId'];
    bannerImg = json['bannerImg'];
    location = json['location'];
    price = json['price'];
    currency = json['currency'];
    month = json['month'];
    startDate = json['startDate'];
    endDate = json['endDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['advertiser_id'] = this.advertiserId;
    data['location_status'] = this.locationStatus;
    data['userId'] = this.userId;
    data['bannerImg'] = this.bannerImg;
    data['location'] = this.location;
    data['price'] = this.price;
    data['currency'] = this.currency;
    data['month'] = this.month;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    return data;
  }
}
