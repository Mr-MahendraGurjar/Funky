class GetPostSettingModel {
  List<PostSetting>? postSetting;
  String? error;
  String? statusCode;
  String? message;

  GetPostSettingModel({this.postSetting, this.error, this.statusCode, this.message});

  GetPostSettingModel.fromJson(Map<String, dynamic> json) {
    if (json['post_setting'] != null) {
      postSetting = <PostSetting>[];
      json['post_setting'].forEach((v) {
        postSetting!.add(new PostSetting.fromJson(v));
      });
    }
    error = json['error'];
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.postSetting != null) {
      data['post_setting'] = this.postSetting!.map((v) => v.toJson()).toList();
    }
    data['error'] = this.error;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}

class PostSetting {
  String? id;
  String? postId;
  String? userId;
  String? allowTagsFrom;
  String? manuallyApproveTag;
  String? likeView;
  String? hideLikeCount;
  String? hideCommentCount;
  String? tagControlManuallyApprove;
  String? tagControlTaggedPost;
  String? mention;
  String? usePost;
  String? saveLiveToDraft;
  String? createdDate;
  String? updatedDate;

  PostSetting(
      {this.id,
      this.postId,
      this.userId,
      this.allowTagsFrom,
      this.manuallyApproveTag,
      this.likeView,
      this.hideLikeCount,
      this.hideCommentCount,
      this.tagControlManuallyApprove,
      this.tagControlTaggedPost,
      this.mention,
      this.usePost,
      this.saveLiveToDraft,
      this.createdDate,
      this.updatedDate});

  PostSetting.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['post_id'];
    userId = json['user_id'];
    allowTagsFrom = json['allow_tags_from'];
    manuallyApproveTag = json['manually_approve_tag'];
    likeView = json['like_view'];
    hideLikeCount = json['hide_like_count'];
    hideCommentCount = json['hide_comment_count'];
    tagControlManuallyApprove = json['tag_control_manually_approve'];
    tagControlTaggedPost = json['tag_control_tagged_post'];
    mention = json['mention'];
    usePost = json['use_post'];
    saveLiveToDraft = json['save_live_to_draft'];
    createdDate = json['createdDate'];
    updatedDate = json['updatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['post_id'] = this.postId;
    data['user_id'] = this.userId;
    data['allow_tags_from'] = this.allowTagsFrom;
    data['manually_approve_tag'] = this.manuallyApproveTag;
    data['like_view'] = this.likeView;
    data['hide_like_count'] = this.hideLikeCount;
    data['hide_comment_count'] = this.hideCommentCount;
    data['tag_control_manually_approve'] = this.tagControlManuallyApprove;
    data['tag_control_tagged_post'] = this.tagControlTaggedPost;
    data['mention'] = this.mention;
    data['use_post'] = this.usePost;
    data['save_live_to_draft'] = this.saveLiveToDraft;
    data['createdDate'] = this.createdDate;
    data['updatedDate'] = this.updatedDate;
    return data;
  }
}
