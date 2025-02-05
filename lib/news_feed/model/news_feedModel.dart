class NewsFeedModel {
  List<Data>? data;
  List<Advertisers>? advertisers;
  bool? error;
  String? statusCode;
  String? message;

  NewsFeedModel(
      {this.data, this.advertisers, this.error, this.statusCode, this.message});

  NewsFeedModel.fromJson(Map<String, dynamic> json) {
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
  String? newsID;
  String? logo;
  String? userName;
  String? fullName;
  String? title;
  String? image;
  String? tagLine;
  String? address;
  String? postImage;
  String? uploadVideo;
  String? isVideo;
  String? feedlikeStatus;
  String? feedLikeCount;
  String? feedCount;
  String? description;
  String? createdDate;
  String? newsFeedUrl;

  Data({
    this.newsID,
    this.logo,
    this.userName,
    this.fullName,
    this.title,
    this.image,
    this.tagLine,
    this.address,
    this.postImage,
    this.uploadVideo,
    this.isVideo,
    this.feedlikeStatus,
    this.feedLikeCount,
    this.feedCount,
    this.description,
    this.createdDate,
    this.newsFeedUrl,
  });

  Data.fromJson(Map<String, dynamic> json) {
    newsID = json['newsID'];
    logo = json['logo'];
    userName = json['userName'];
    fullName = json['fullName'];
    title = json['title'];
    image = json['image'];
    tagLine = json['tagLine'];
    address = json['address'];
    postImage = json['postImage'];
    uploadVideo = json['uploadVideo'];
    isVideo = json['isVideo'];
    feedlikeStatus = json['feedlikeStatus'];
    feedLikeCount = json['feedLike_count'];
    feedCount = json['feedCount'];
    description = json['description'];
    createdDate = json['createdDate'];
    newsFeedUrl = json['newsfeed_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['newsID'] = newsID;
    data['logo'] = logo;
    data['userName'] = userName;
    data['fullName'] = fullName;
    data['title'] = title;
    data['image'] = image;
    data['tagLine'] = tagLine;
    data['address'] = address;
    data['postImage'] = postImage;
    data['uploadVideo'] = uploadVideo;
    data['isVideo'] = isVideo;
    data['feedlikeStatus'] = feedlikeStatus;
    data['feedLike_count'] = feedLikeCount;
    data['feedCount'] = feedCount;
    data['description'] = description;
    data['createdDate'] = createdDate;
    data['newsfeed_url'] = newsFeedUrl;
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
