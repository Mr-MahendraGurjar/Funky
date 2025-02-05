class GetDiscoverModel {
  List<Data>? data;
  List<Advertisers>? advertisers;
  bool? error;
  String? statusCode;
  String? message;

  GetDiscoverModel(
      {this.data, this.advertisers, this.error, this.statusCode, this.message});

  GetDiscoverModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    if (json['advertisers'] != null) {
      advertisers = <Advertisers>[];
      json['advertisers'].forEach((v) {
        advertisers!.add(Advertisers.fromJson(v));
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
    if (advertisers != null) {
      data['advertisers'] = advertisers!.map((v) => v.toJson()).toList();
    }
    data['error'] = error;
    data['status_code'] = statusCode;
    data['message'] = message;
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
  String? coverImage;
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
      this.coverImage,
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
    coverImage = json['coverImage'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['fullName'] = fullName;
    data['userName'] = userName;
    data['OriginalAudioName'] = originalAudioName;
    data['musicName'] = musicName;
    data['image'] = image;
    data['tagLine'] = tagLine;
    data['description'] = description;
    data['address'] = address;
    data['postImage'] = postImage;
    data['uploadVideo'] = uploadVideo;
    data['isVideo'] = isVideo;
    data['likes'] = likes;
    data['likeStatus'] = likeStatus;
    data['commentCount'] = commentCount;
    data['shareCount'] = shareCount;
    data['rewardCount'] = rewardCount;
    data['viewsCount'] = viewsCount;
    data['createdDate'] = createdDate;
    if (user != null) {
      data['user'] = user!.toJson();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['advertiser_id'] = advertiserId;
    data['location_status'] = locationStatus;
    data['userId'] = userId;
    data['bannerImg'] = bannerImg;
    data['location'] = location;
    data['price'] = price;
    data['currency'] = currency;
    data['month'] = month;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    return data;
  }
}
