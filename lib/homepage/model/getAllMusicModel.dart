class GetAllMusicModel {
  List<Data_music>? data;
  bool? error;
  String? statusCode;
  String? message;

  GetAllMusicModel({this.data, this.error, this.statusCode, this.message});

  GetAllMusicModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data_music>[];
      json['data'].forEach((v) {
        data!.add(new Data_music.fromJson(v));
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

class Data_music {
  String? id;
  String? userId;
  String? songName;
  String? artistName;
  String? musicFile;
  String? price;
  User? user;

  Data_music({this.id, this.userId, this.songName, this.artistName, this.musicFile, this.price, this.user});

  Data_music.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    songName = json['song_name'];
    artistName = json['artist_name'];
    musicFile = json['music_file'];
    price = json['price'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['song_name'] = this.songName;
    data['artist_name'] = this.artistName;
    data['music_file'] = this.musicFile;
    data['price'] = this.price;
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
