class ImageListModel {
  List<Data_image>? data;
  bool? error;
  String? statusCode;
  String? message;

  ImageListModel({this.data, this.error, this.statusCode, this.message});

  ImageListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data_image>[];
      json['data'].forEach((v) {
        data!.add(new Data_image.fromJson(v));
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

class Data_image {
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
  String? likeCountStatus;
  String? likes;
  String? isCommercial;
  String? likeStatus;
  String? commentCountStatus;
  String? usePost;
  String? commentVideoPhoto;
  String? commentCount;
  String? shareCount;
  String? rewardCount;
  String? viewsCount;
  String? enableDownload;
  String? enableComment;
  String? createdDate;
  User? user;
  Advertiser? advertiser;

  Data_image(
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
      this.likeCountStatus,
      this.likes,
      this.isCommercial,
      this.likeStatus,
      this.commentCountStatus,
      this.usePost,
      this.commentVideoPhoto,
      this.commentCount,
      this.shareCount,
      this.rewardCount,
      this.viewsCount,
      this.enableDownload,
      this.enableComment,
      this.createdDate,
      this.user,
      this.advertiser});

  Data_image.fromJson(Map<String, dynamic> json) {
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
    likeCountStatus = json['like_count_status'];
    likes = json['likes'];
    isCommercial = json['isCommercial'];
    likeStatus = json['likeStatus'];
    commentCountStatus = json['comment_count_status'];
    usePost = json['use_post'];
    commentVideoPhoto = json['comment_video_photo'];
    commentCount = json['commentCount'];
    shareCount = json['shareCount'];
    rewardCount = json['rewardCount'];
    viewsCount = json['viewsCount'];
    enableDownload = json['enableDownload'];
    enableComment = json['enableComment'];
    createdDate = json['createdDate'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    advertiser = json['advertiser'] != null ? new Advertiser.fromJson(json['advertiser']) : null;
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
    data['like_count_status'] = this.likeCountStatus;
    data['likes'] = this.likes;
    data['isCommercial'] = this.isCommercial;
    data['likeStatus'] = this.likeStatus;
    data['comment_count_status'] = this.commentCountStatus;
    data['use_post'] = this.usePost;
    data['comment_video_photo'] = this.commentVideoPhoto;
    data['commentCount'] = this.commentCount;
    data['shareCount'] = this.shareCount;
    data['rewardCount'] = this.rewardCount;
    data['viewsCount'] = this.viewsCount;
    data['enableDownload'] = this.enableDownload;
    data['enableComment'] = this.enableComment;
    data['createdDate'] = this.createdDate;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.advertiser != null) {
      data['advertiser'] = this.advertiser!.toJson();
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

class Advertiser {
  String? id;
  String? userId;
  String? logo;
  String? price;
  String? currency;
  String? placeLocation;
  String? brandStartDate;
  String? brandEndDate;

  Advertiser(
      {this.id,
      this.userId,
      this.logo,
      this.price,
      this.currency,
      this.placeLocation,
      this.brandStartDate,
      this.brandEndDate});

  Advertiser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    logo = json['logo'];
    price = json['price'];
    currency = json['currency'];
    placeLocation = json['place_location'];
    brandStartDate = json['brand_startDate'];
    brandEndDate = json['brand_endDate'];
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
    return data;
  }
}
