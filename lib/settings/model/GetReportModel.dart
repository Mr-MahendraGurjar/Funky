class GetReportProblem {
  bool? error;
  String? statusCode;
  String? message;
  List<Data>? data;

  GetReportProblem({this.error, this.statusCode, this.message, this.data});

  GetReportProblem.fromJson(Map<String, dynamic> json) {
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
  String? receiverUserId;
  String? typeId;
  String? type;
  String? title;
  String? description;
  String? createdDate;
  String? updatedDate;
  List<Image>? image;

  Data(
      {this.id,
      this.userId,
      this.receiverUserId,
      this.typeId,
      this.type,
      this.title,
      this.description,
      this.createdDate,
      this.updatedDate,
      this.image});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    receiverUserId = json['receiver_user_id'];
    typeId = json['type_id'];
    type = json['type'];
    title = json['title'];
    description = json['description'];
    createdDate = json['createdDate'];
    updatedDate = json['updatedDate'];
    if (json['image'] != null) {
      image = <Image>[];
      json['image'].forEach((v) {
        image!.add(new Image.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['receiver_user_id'] = this.receiverUserId;
    data['type_id'] = this.typeId;
    data['type'] = this.type;
    data['title'] = this.title;
    data['description'] = this.description;
    data['createdDate'] = this.createdDate;
    data['updatedDate'] = this.updatedDate;
    if (this.image != null) {
      data['image'] = this.image!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Image {
  String? id;
  String? reportProblemId;
  String? image;
  String? createdDate;
  String? updatedDate;

  Image({this.id, this.reportProblemId, this.image, this.createdDate, this.updatedDate});

  Image.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reportProblemId = json['report_problem_id'];
    image = json['image'];
    createdDate = json['createdDate'];
    updatedDate = json['updatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['report_problem_id'] = this.reportProblemId;
    data['image'] = this.image;
    data['createdDate'] = this.createdDate;
    data['updatedDate'] = this.updatedDate;
    return data;
  }
}
