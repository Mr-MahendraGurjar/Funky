class SendOtpModel {
  List<User>? user;
  bool? error;
  String? statusCode;
  String? message;

  SendOtpModel({this.user, this.error, this.statusCode, this.message});

  SendOtpModel.fromJson(Map<String, dynamic> json) {
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
  String? from;
  String? to;
  String? body;
  int? id;

  User({this.from, this.to, this.body, this.id});

  User.fromJson(Map<String, dynamic> json) {
    from = json['From'];
    to = json['To'];
    body = json['Body'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['From'] = from;
    data['To'] = to;
    data['Body'] = body;
    data['id'] = id;
    return data;
  }
}
