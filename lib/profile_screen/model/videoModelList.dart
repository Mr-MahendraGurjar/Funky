class VideoModelList {
  List<Data_profile_video>? data;
  bool? error;
  String? statusCode;
  String? message;

  VideoModelList({this.data, this.error, this.statusCode, this.message});

  VideoModelList.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data_profile_video>[];
      json['data'].forEach((v) {
        data!.add(new Data_profile_video.fromJson(v));
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

class Data_profile_video {
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
  String? coverImage;
  String? uploadVideo;
  String? isVideo;
  String? likes;
  String? isCommercial;
  String? likeStatus;
  String? commentCount;
  String? shareCount;
  String? rewardCount;
  String? viewsCount;
  String? enableDownload;
  String? enableComment;
  String? createdDate;
  User? user;

  Data_profile_video(
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
      this.coverImage,
      this.uploadVideo,
      this.isVideo,
      this.likes,
      this.isCommercial,
      this.likeStatus,
      this.commentCount,
      this.shareCount,
      this.rewardCount,
      this.viewsCount,
      this.enableDownload,
      this.enableComment,
      this.createdDate,
      this.user});

  Data_profile_video.fromJson(Map<String, dynamic> json) {
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
    coverImage = json['coverImage'];
    uploadVideo = json['uploadVideo'];
    isVideo = json['isVideo'];
    likes = json['likes'];
    isCommercial = json['isCommercial'];
    likeStatus = json['likeStatus'];
    commentCount = json['commentCount'];
    shareCount = json['shareCount'];
    rewardCount = json['rewardCount'];
    viewsCount = json['viewsCount'];
    enableDownload = json['enableDownload'];
    enableComment = json['enableComment'];
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
    data['coverImage'] = this.coverImage;
    data['uploadVideo'] = this.uploadVideo;
    data['isVideo'] = this.isVideo;
    data['likes'] = this.likes;
    data['isCommercial'] = this.isCommercial;
    data['likeStatus'] = this.likeStatus;
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
  String? verify;
  String? followerFollowingShowStatus;
  String? socialLinkShowStatus;
  String? facebookLinks;
  String? instagramLinks;
  String? tiktokLinks;
  String? twitterLinks;
  String? snapchatLinks;
  String? linkedinLinks;
  String? gmailLinks;
  String? whatsappLinks;
  String? skypeLinks;
  String? youtubeLinks;
  String? pinterestLinks;
  String? redditLinks;
  String? telegramLinks;
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
      this.verify,
      this.followerFollowingShowStatus,
      this.socialLinkShowStatus,
      this.facebookLinks,
      this.instagramLinks,
      this.tiktokLinks,
      this.twitterLinks,
      this.snapchatLinks,
      this.linkedinLinks,
      this.gmailLinks,
      this.whatsappLinks,
      this.skypeLinks,
      this.youtubeLinks,
      this.pinterestLinks,
      this.redditLinks,
      this.telegramLinks,
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
    verify = json['verify'];
    followerFollowingShowStatus = json['follower_following_show_status'];
    socialLinkShowStatus = json['social_link_show_status'];
    facebookLinks = json['facebook_links'];
    instagramLinks = json['instagram_links'];
    tiktokLinks = json['tiktok_links'];
    twitterLinks = json['twitter_links'];
    snapchatLinks = json['snapchat_links'];
    linkedinLinks = json['linkedin_links'];
    gmailLinks = json['gmail_links'];
    whatsappLinks = json['whatsapp_links'];
    skypeLinks = json['skype_links'];
    youtubeLinks = json['youtube_links'];
    pinterestLinks = json['pinterest_links'];
    redditLinks = json['reddit_links'];
    telegramLinks = json['telegram_links'];
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
    data['verify'] = this.verify;
    data['follower_following_show_status'] = this.followerFollowingShowStatus;
    data['social_link_show_status'] = this.socialLinkShowStatus;
    data['facebook_links'] = this.facebookLinks;
    data['instagram_links'] = this.instagramLinks;
    data['tiktok_links'] = this.tiktokLinks;
    data['twitter_links'] = this.twitterLinks;
    data['snapchat_links'] = this.snapchatLinks;
    data['linkedin_links'] = this.linkedinLinks;
    data['gmail_links'] = this.gmailLinks;
    data['whatsapp_links'] = this.whatsappLinks;
    data['skype_links'] = this.skypeLinks;
    data['youtube_links'] = this.youtubeLinks;
    data['pinterest_links'] = this.pinterestLinks;
    data['reddit_links'] = this.redditLinks;
    data['telegram_links'] = this.telegramLinks;
    data['createdDate'] = this.createdDate;
    return data;
  }
}
