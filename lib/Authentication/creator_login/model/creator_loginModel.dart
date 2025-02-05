class LoginModel {
  List<User>? user;
  bool? error;
  String? statusCode;
  String? message;

  LoginModel({this.user, this.error, this.statusCode, this.message});

  LoginModel.fromJson(Map<String, dynamic> json) {
    if (json['user'] != null) {
      user = <User>[];
      json['user'].forEach((v) {
        user!.add(User.fromJson(v));
      });
    }
    error = json['error'];
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.map((v) => v.toJson()).toList();
    }
    data['error'] = error;
    data['status_code'] = statusCode;
    data['message'] = message;
    return data;
  }
}

class User {
  String? id;
  String? type;
  String? userName;
  String? textMessage;
  String? deletedDate;
  String? token;

  User(
      {this.id,
      this.type,
      this.userName,
      this.textMessage,
      this.deletedDate,
      this.token});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    userName = json['userName'];
    textMessage = json['text_message'];
    deletedDate = json['deletedDate'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['userName'] = userName;
    data['text_message'] = textMessage;
    data['deletedDate'] = deletedDate;
    data['token'] = token;
    return data;
  }
}

class CheckUserModel {
  String? statusCode;
  bool? error;
  String? message;

  CheckUserModel({this.statusCode, this.error, this.message});

  CheckUserModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    error = json['error'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status_code'] = statusCode;
    data['error'] = error;
    data['message'] = message;
    return data;
  }
}
