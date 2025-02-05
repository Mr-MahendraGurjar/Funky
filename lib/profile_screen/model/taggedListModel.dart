class TaggedListModel {
  List<TagList>? tagList;
  bool? error;
  String? statusCode;
  String? message;

  TaggedListModel({this.tagList, this.error, this.statusCode, this.message});

  TaggedListModel.fromJson(Map<String, dynamic> json) {
    if (json['tag_list'] != null) {
      tagList = <TagList>[];
      json['tag_list'].forEach((v) {
        tagList!.add(new TagList.fromJson(v));
      });
    }
    error = json['error'];
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tagList != null) {
      data['tag_list'] = this.tagList!.map((v) => v.toJson()).toList();
    }
    data['error'] = this.error;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}

class TagList {
  String? id;
  String? fullName;
  String? userName;
  String? email;
  String? image;
  String? type;

  TagList({this.id, this.fullName, this.userName, this.email, this.image, this.type});

  TagList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    userName = json['userName'];
    email = json['email'];
    image = json['image'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullName'] = this.fullName;
    data['userName'] = this.userName;
    data['email'] = this.email;
    data['image'] = this.image;
    data['type'] = this.type;
    return data;
  }
}
