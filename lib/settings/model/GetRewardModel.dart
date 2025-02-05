class GetRewardModel {
  List<RewardList>? rewardList;
  String? totalReward;
  String? statusCode;
  bool? error;
  String? message;

  GetRewardModel({this.rewardList, this.totalReward, this.statusCode, this.error, this.message});

  GetRewardModel.fromJson(Map<String, dynamic> json) {
    if (json['reward_list'] != null) {
      rewardList = <RewardList>[];
      json['reward_list'].forEach((v) {
        rewardList!.add(new RewardList.fromJson(v));
      });
    }
    totalReward = json['total_reward'];
    statusCode = json['status_code'];
    error = json['error'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.rewardList != null) {
      data['reward_list'] = this.rewardList!.map((v) => v.toJson()).toList();
    }
    data['total_reward'] = this.totalReward;
    data['status_code'] = this.statusCode;
    data['error'] = this.error;
    data['message'] = this.message;
    return data;
  }
}

class RewardList {
  String? userId;
  String? rewardPoint;
  String? title;

  RewardList({this.userId, this.rewardPoint, this.title});

  RewardList.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    rewardPoint = json['reward_point'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['reward_point'] = this.rewardPoint;
    data['title'] = this.title;
    return data;
  }
}
