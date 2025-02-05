class GetDraftListModel {
  bool? error;
  String? statusCode;
  String? message;
  List<Data_draft>? data;

  GetDraftListModel({this.error, this.statusCode, this.message, this.data});

  GetDraftListModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data_draft>[];
      json['data'].forEach((v) {
        data!.add(new Data_draft.fromJson(v));
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

class Data_draft {
  String? postId;
  String? tagLine;
  String? description;
  String? address;
  String? postImage;
  String? uploadVideo;
  String? coverImage;
  String? isVideo;
  String? isCommercial;
  String? enableDownload;
  String? enableComment;
  String? allowAds;
  User? user;
  Commercial? commercial;

  Data_draft(
      {this.postId,
      this.tagLine,
      this.description,
      this.address,
      this.postImage,
      this.uploadVideo,
      this.coverImage,
      this.isVideo,
      this.isCommercial,
      this.enableDownload,
      this.enableComment,
      this.allowAds,
      this.user,
      this.commercial});

  Data_draft.fromJson(Map<String, dynamic> json) {
    postId = json['postId'];
    tagLine = json['tagLine'];
    description = json['description'];
    address = json['address'];
    postImage = json['postImage'];
    uploadVideo = json['uploadVideo'];
    coverImage = json['coverImage'];
    isVideo = json['isVideo'];
    isCommercial = json['isCommercial'];
    enableDownload = json['enableDownload'];
    enableComment = json['enableComment'];
    allowAds = json['allowAds'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    commercial = json['commercial'] != null ? new Commercial.fromJson(json['commercial']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['postId'] = this.postId;
    data['tagLine'] = this.tagLine;
    data['description'] = this.description;
    data['address'] = this.address;
    data['postImage'] = this.postImage;
    data['uploadVideo'] = this.uploadVideo;
    data['coverImage'] = this.coverImage;
    data['isVideo'] = this.isVideo;
    data['isCommercial'] = this.isCommercial;
    data['enableDownload'] = this.enableDownload;
    data['enableComment'] = this.enableComment;
    data['allowAds'] = this.allowAds;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.commercial != null) {
      data['commercial'] = this.commercial!.toJson();
    }
    return data;
  }
}

class User {
  String? userId;

  User({this.userId});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    return data;
  }
}

class Commercial {
  String? id;
  String? userId;
  String? postid;
  String? video;
  String? price;
  String? currency;
  String? month;
  String? addDescription;
  String? placeLocation;
  String? taggedPeople;
  String? isCommercial;
  String? videoCreatedDate;
  String? videoUpdatedDate;

  Commercial(
      {this.id,
      this.userId,
      this.postid,
      this.video,
      this.price,
      this.currency,
      this.month,
      this.addDescription,
      this.placeLocation,
      this.taggedPeople,
      this.isCommercial,
      this.videoCreatedDate,
      this.videoUpdatedDate});

  Commercial.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    postid = json['postid'];
    video = json['video'];
    price = json['price'];
    currency = json['currency'];
    month = json['month'];
    addDescription = json['add_description'];
    placeLocation = json['place_location'];
    taggedPeople = json['tagged_people'];
    isCommercial = json['isCommercial'];
    videoCreatedDate = json['video_createdDate'];
    videoUpdatedDate = json['video_updatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['postid'] = this.postid;
    data['video'] = this.video;
    data['price'] = this.price;
    data['currency'] = this.currency;
    data['month'] = this.month;
    data['add_description'] = this.addDescription;
    data['place_location'] = this.placeLocation;
    data['tagged_people'] = this.taggedPeople;
    data['isCommercial'] = this.isCommercial;
    data['video_createdDate'] = this.videoCreatedDate;
    data['video_updatedDate'] = this.videoUpdatedDate;
    return data;
  }
}
